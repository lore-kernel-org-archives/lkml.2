Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab1C1OVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:21:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab1C1OU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:20:58 -0400
Date: Mon, 28 Mar 2011 16:20:57 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
 computation for COMPAT_BRK
In-Reply-To: <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1103281619320.26754@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz> <alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz> <AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
 <alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz> <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Geert Uytterhoeven wrote:

> >> | RAMDISK: gzip image found at block 0
> >> | VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
> >> | warning: process `update' used the obsolete bdflush system call
> >> | Fix your initscripts?
> >> | init: cannot open inittab
> >> | Kernel panic - not syncing: Attempted to kill init!
> >>
> >> Sorry for not noticing earlier, I usually boot full Debians under ARAnyM,
> >> instead of booting old ramdisks with libc5-based binaries that once were
> >> considered new.
> >
> > Oh well, one has to love the libc5-based binaries indeed.
> 
> Yeah, binaries from 1996 ;-)
> 
> > Is the patch below fixing the issue you are seeing on your Amiga/m68k?
> > Thanks.
> >
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 2ec8eb5..0a02531 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -262,7 +262,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
> >        if (mm->start_brk > PAGE_ALIGN(mm->end_data))
> >                min_brk = mm->start_brk;
> >        else
> > -               min_brk = mm->end_data;
> > +               min_brk = mm->end_code;
> >  #else
> >        min_brk = mm->start_brk;
> >  #endif
> 
> Unfortunately not...
> 
> I added some printk()s:
> 
> mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
> mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
> mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
> mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
> mm->start_brk = 0x80006000, PAGE_ALIGN(mm->end_data = 0x80004000)
> 
> I.e. just before the failure, "mm->start_brk > PAGE_ALIGN(mm->end_data)"
> became true.

Hmm, I think we'd need some refresh on what the ancient libc5-based 
binaries are actually doing.

Could you please send me strace of this application (restricting it to 
brk()/mmap() calls should be enough).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
