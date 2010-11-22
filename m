Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab0KVK3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 05:29:14 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:52990 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab0KVK3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 05:29:13 -0500
Message-ID: <1290421744.4cea45f0614d4@imp.free.fr>
Date: Mon, 22 Nov 2010 11:29:04 +0100
From: castet.matthieu@free.fr
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX protection for kernel data)
References: <1290410581.2405.24.camel@minggr.sh.intel.com> <20101122080710.GA1510@elte.hu> <20101122092003.GA21836@basil.fritz.box>
In-Reply-To: <20101122092003.GA21836@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 93.1.148.21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Quoting Andi Kleen <andi@firstfloor.org>:

> On Mon, Nov 22, 2010 at 09:07:10AM +0100, Ingo Molnar wrote:
> > > ---[ High Kernel Mapping ]---
> > > ....
> > > 0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB
> NX pmd
> > > 0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB
> NX pte
> > > 0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB
> NX pte
> > > 0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB
> NX pmd
> > > 0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB
> NX pte
> > > 0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB
> NX pte
> > > 0xffffffff82100000-0xffffffff82200000           1M     RW             GLB
> NX pte
> > > .....
> > >
> > > The only difference is 0xffffffff81e00000(end) to
> 0xffffffff82200000(kernel_end) is set to NX.
> > >
> > > I guess this range code is used by resume wakeup code. So setting it to
> NX causes problem.
> > >
> > > Any idea?
> >
> > Yeah, the resume area is a trampoline, it needs to be executable.
>
> Also it looks like most of the kernel linker supplied data is now not
> 2MB mapped anymore? That will surely cost TLB entries.
>
Any idea where it comes from ?

The mapping is still not 2MB mapped without the commit.

The patch only add

+#if defined(CONFIG_DEBUG_RODATA)
+	/* .text should occupy whole number of pages */
+	. = ALIGN(PAGE_SIZE);
+#endif
 	X64_ALIGN_DEBUG_RODATA_BEGIN
 	RO_DATA(PAGE_SIZE)
 	X64_ALIGN_DEBUG_RODATA_END

But X64_ALIGN_DEBUG_RODATA_BEGIN is aligned on 2M, so it shouldn't change
nothing on x64 ?

Matthieu
