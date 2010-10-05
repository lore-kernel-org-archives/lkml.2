Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab0JELOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:14:37 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:40160 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0JELOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:14:36 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Oct 2010 07:14:36 EDT
Date: Tue, 5 Oct 2010 14:08:30 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Message-ID: <20101005110830.GA30583@localhost.pp.htv.fi>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
 <201010051448.34984.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <201010051448.34984.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 02:48:34PM +1030, Rusty Russell wrote:
> On Mon, 4 Oct 2010 06:21:08 am Thomas Gleixner wrote:
> > Current mainline triggers a list corruption bug in
> > module_bug_finalize(). dmesg excerpt below.
> > 
> > The corresponding code says:
> > 
> >         /*
> >          * Strictly speaking this should have a spinlock to protect against
> >          * traversals, but since we only traverse on BUG()s, a spinlock
> >          * could potentially lead to deadlock and thus be counter-productive.
> >          */
> >         list_add(&mod->bug_list, &module_bug_list);
> > 
> > I can see the traversal problem vs. BUG(), but what's protecting the
> > list_add() ? BKL probably did, but is that true anymore ?
> 
> I've never even *seen* this code before :(
> 
> Looks like it went through Adrian Bunk to Andrew,
>...

    [bunk@stusta.de: include/linux/bug.h must always #include <linux/module.h]
    Signed-off-by: Adrian Bunk <bunk@stusta.de>

The commit did not went through me, and I did never review or forward it.

My Signed-off-by: was for the change I sent against the original patch, 
and it was added to the commit when Andrew included my change into the
original patch.

> but despite the fact that
> it (foolishly) doesn't touch kernel/module.c, it's generic code and I should
> have seen it.  It did change the linux/module.h header.
>...

The commit says
    Cc: Rusty Russell <rusty@rustcorp.com.au>

When Andrew submitted it to Linus that should have resulted in an email
to you by the script Andrew uses for submitting patches.

And according to my mail archives that did happen:

Message-Id: <200612081036.kB8AaJDK016473@shell0.pdx.osdl.net>
Subject: [patch 027/368] Generic BUG implementation
To: torvalds@osdl.org
Cc: akpm@osdl.org,
    jeremy@goop.org,
    ak@muc.de,
    benh@kernel.crashing.org,
    bunk@stusta.de,
    hugh@veritas.com,
    michael@ellerman.id.au,
    paulus@samba.org,
    rusty@rustcorp.com.au
From: akpm@osdl.org
Date: Fri, 08 Dec 2006 02:36:19 -0800


> Nice catch!
> Rusty.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

