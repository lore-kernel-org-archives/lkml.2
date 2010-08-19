Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab0HSMoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:44:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab0HSMo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:44:29 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Thu, 19 Aug 2010 14:44:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008181747.15461.agruen@suse.de> <1282147146.21419.165.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282147146.21419.165.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191444.08966.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 August 2010 17:59:06 Eric Paris wrote:
> I'm going to file your e-mail into my todo list and hopefully I get the
> time to look at the ability to ignore directory events.

As far as I can remember, several people involved in the previous discussion 
agreed that a reasonable goal would be to make fanotify  a superset of 
inotify.  My understanding was that this would be the general direction of 
development.  The code apparently is not there yet; it only reports a subset 
of the relevant directory events.  (In other words, the directory event part 
of the code is currently useless.)  Given that, I was surprised to see the 
code getting merged.

Fanotify has a subset of functionality for watching and vetting regular file 
accesses which seems to be useful in its own right; the anti-malware folks 
want this part.  Implementing only this part was not what was originally 
discussed, but I can see some arguments for putting this functionality in now 
(or rather leaving it in) and adding the rest later.

The half-thought-out directory events are not part of this subset though.  
They are not useful in their own right and only generate overheads, and much 
worse, they could even get in the way when proper directory event support is 
eventually added.  So that part should really be removed ASAP.

I expect more from you than just ignoring my concerns as you imply.

> Nothing hard about it.  It's as easy as defining a flag and adding a
> conditional in the code but it's not high on my list.

We are not talking about Eric's own private syscalls here.  Things we screw up 
now may be very hard or impossible to fix later; syscalls don't just change 
from release to release.

This also applies to the error reporting mess I have commented on.  At least 
the interface should be changed so that it can report a valid file descriptor 
and an error condition at the same time; otherwise, we will end up with a 
weakness in the interface that we won't be able to fix.

Andreas
