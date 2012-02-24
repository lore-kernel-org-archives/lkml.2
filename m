Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2BXSBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:01:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab2BXSBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:01:16 -0500
Date: Fri, 24 Feb 2012 19:01:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 3.3-rc4
In-Reply-To: <CA+55aFwg4EpUhbymOHrSt88FEmZWniMx4goCkk-xK7dwiKcsZg@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1202241859160.31150@pobox.suse.cz>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com> <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz> <CA+55aFwg4EpUhbymOHrSt88FEmZWniMx4goCkk-xK7dwiKcsZg@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Linus Torvalds wrote:

> > The machine has gone through several suspend-resume cycles before this
> > happened, so it might well also be some memory corruption caused by a
> > random driver.
> 
> I almost think it is, because "file->dentry" should never be NULL in a
> mapping afaik. Especially as your "mapping" certainly isn't NULL (it's
> in %r12, so you can see it in your register dump).
> 
> This isn't some unusual code sequence either, so I don't see it as
> some random latent bug that is just very unlikely and hard to trigger
> in that code itself.
> 
> I'll think about it, but my first reaction is "memory corruption". Do
> you think you could try to run with a kernel that has SLAB debugging
> and poisoning on? If it's a stale pointer dereference that has cleared
> that dentry, that _might_ show it closer to the actual bug (rather
> than a long time later when the NULL dereference happens).

Running DEBUG_SLAB kernel since I have first hit the bug, but nothing 
popped up yet. Seems undebuggable so far.

On the other hand I wouldn't blame HW for a bit-flip, as it was a clear 
NULL pointer (plus 0x30 offset), not a random garbage.

-- 
Jiri Kosina
SUSE Labs
