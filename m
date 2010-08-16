Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab0HPUcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 16:32:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab0HPUcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 16:32:52 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Mon, 16 Aug 2010 22:32:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <20100807000624.GA14819@infradead.org> <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
In-Reply-To: <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008162232.36873.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 August 2010 21:15:14 Eric Paris wrote:
> On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> > I'm also totally missing on any re-post of these patches or discussion
> > of the changes during the last development window.
> 
> I just searched lkml an fsdevel where I usually send everything don't
> see then.  I totally failed.

Oh yes.

This introduces two new syscalls which will be impossible to fix up after the 
fact, and those system calls are poorly documented: commits 2a3edf86 and 
52c923dd document the initial versions (in the commit message!), but 
subsequent commits then extend that interface.  The interface for replying to 
events is not documented at all beyond the example code [1].  There is no 
documentation in Documentation/filesystems/, either.

	[1] http://people.redhat.com/~eparis/fanotify/


Q: What happens when a process watching for FAN_OPEN_PERM or FAN_ACCESS_PERM 
events exits or dies while events are in flight?  I can't see anything in the 
code that would wake sleeping processes up when the fsnotify_group of the 
listener is torn down.


Q: What prevents the system from going out of memory when a listener decides 
to stop reading events or simply can't keep up?  There doesn't seem to be a 
limit on the queue depth.  Listeners currently need CAP_SYS_ADMIN, but somehow 
limiting the queue depth and throttling when things start to go bad still 
sounds like a reasonable thing to do, right?)


Don't get me wrong, I really appreciate your work on this (this shows through 
the patches I've committed), and what we have now is a lot better than what we 
had before.


Thanks,
Andreas
