Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab0JTNL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:11:28 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:60386 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab0JTNL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:11:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19646.59971.76978.642955@quad.stoffel.home>
Date: Wed, 20 Oct 2010 09:10:27 -0400
From: "John Stoffel" <john@stoffel.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
In-Reply-To: <1287512182.3167.130.camel@localhost.localdomain>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	<AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
	<1287506215.2530.187.camel@localhost.localdomain>
	<20101019165530.GT19804@ZenIV.linux.org.uk>
	<AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
	<20101019172805.GU19804@ZenIV.linux.org.uk>
	<1287512182.3167.130.camel@localhost.localdomain>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mimi" == Mimi Zohar <zohar@linux.vnet.ibm.com> writes:

Mimi> On Tue, 2010-10-19 at 18:28 +0100, Al Viro wrote:
>> On Tue, Oct 19, 2010 at 10:03:48AM -0700, Linus Torvalds wrote:
>> > On Tue, Oct 19, 2010 at 9:55 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > >
>> > > a) i_writecount is about VM_DENYWRITE, basically. ?Reusing it for ima could
>> > > get unpleasant; when it's positive, we are fine, but it can get negative as
>> > > well. ?IMA will have interesting time dealing with that.
>> > >
>> > > b) i_count is simply a refcount for struct inode. ?Not exactly the number
>> > > of dentries, but that's the main contributor. ?Basically, that's "how many
>> > > pointers outside of inode hash chains point that that struct inode at the
>> > > moment".
>> > 
>> > My question was deeper. More along the lines of "why would IMA care?"
>> > 
>> > How/why could IMA ever care about the pointless and trivial
>> > differences between its current private open/read/write counts and the
>> > counts that we already maintain?
>> > 
>> > Yes, yes, I realize that they have technical differences in what they
>> > count. That's not the question. The question is "Why would IMA care?"

Mimi> The filesystem prevents files being executed from being opened
Mimi> for write.  The same guarantees that the file won't change,
Mimi> obviously, doesn't exist for files being opened for read. Thus
Mimi> measuring a file opened for read that has already been open for
Mimi> write, has no meaning.  Unfortunately, since the inode counters
Mimi> don't provide this information, IMA maintains a separate set of
Mimi> counters.

Does this mean I can't replace /bin/sh on a running system using IMA
at all, even if just one process has it opened and is running?  So how
the hell am I supposed to do live upgrades on a system?  

Currently, /bin/sh gets replaced with the newer, better (for some
value of better :-) version, while currently running users aren't
impacted at all.  New users pick up the new binary.

Gah!  The only way to upgrade such a system would look be via a
reboot.  Not very nice at all... or can the root user disable IMA,
upgrade a binary, then re-start IMA on a system?  

So how does this improve security if root is compromised?

John
