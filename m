Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0JZNyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 09:54:39 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:47809 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0JZNyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 09:54:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19654.56681.488563.135215@quad.stoffel.home>
Date: Tue, 26 Oct 2010 09:53:45 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 06/11] IMA: use i_writecount rather than a private
 counter
In-Reply-To: <1288043557.2655.34.camel@localhost.localdomain>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	<20101025184152.20504.94048.stgit@paris.rdu.redhat.com>
	<19653.55831.692904.538148@quad.stoffel.home>
	<1288043557.2655.34.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Mon, 2010-10-25 at 15:27 -0400, John Stoffel wrote:
>> The problems with kernel.org is a perfect exmaple of how an annocuous
>> feature like this, can kill a system's performance.

Eric> You admit that you don't know what you are talking about and
Eric> then state that this kills systems performance.  Interesting
Eric> conclusion.

I'm basing my observations on the data reported by John "Warthog9"
who's the kernel.org sysadmin, and the *fact* that IMA was chewing up
gigs of memory when it wasn't even enabled, but just compiled into the
system.

It certainly does NOT help system performance to suck up RAM with data
that is NEVER used by that system.  

Eric> I'm not going to try to refute you point by point but will instead paint
Eric> a broad picture.  I see 3 possible states:

Eric> 1) Configured out - 0 overhead.  period.

Excellent, this should be the default and the Kconfig should be
updated to default to this.  

Eric> 2) Configured in but default disabled

And what is the overhead in this case?  That's what I'm concerned
about.  

Eric> 3) Configured in and enabled by admin intervention

I can't complain about this aspect, though I can still push for the
lowest possible impact on system performance when *any* of these
last two states are in force.  

Eric> I have (I think) pretty clearly discussed the overhead and the
Eric> changes made in case #2.  We expand struct inode by 4 bytes, we
Eric> increment and decrement those 4 bytes on open/close() and we use
Eric> a new inode->i_flags.

Then this is a huge improvement!  Don't get me wrong, I'm negative
about IMA in general, but I'm very happy at how well you've responded
to the firestorm of criticism (even from me, a non-kernel programmer)
about this subsystem. 

Eric> In you e-mail you seemed to be asking about case #3 where you
Eric> explicitly chose to load a measurement policy (either custom or
Eric> using the imb_tcb=1 boot option).  There are additional
Eric> overheads in that case if the inode in question matches the
Eric> measurement policy.  I don't see the need to go into the details
Eric> of that overhead since you have 0 intention of using this
Eric> feature no matter what and don't seem to be interested in
Eric> helping to change those overheads for users of the subsystem.
Eric> Please correct me if I'm wrong.  I do readily admit there is
Eric> overhead, and that overhead will be higher if inodes which have
Eric> been deemed integrity relevant by the measurement policy you
Eric> chose to load are changed in certain patterns.

No.  What I was trying to get at, and probably poorly, was the comment
you made about having to keep the IMA data structures around, even if
IMA has been disabled, so that you could continue to claim integrity
if IMA was re-enabled.

So my question is really about the following situation:

1.  System boots up, IMA is enabled.
2.  SysAdmin notices and turns it off.
    - does the IMA overhead (not the per-inode 4 bytes) go away?
    - do the various in memory data structures get freed?
    - does the pointer in the inode get null'ed?

Thanks,
John



