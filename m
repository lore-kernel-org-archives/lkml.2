Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0KVJUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 04:20:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54397 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0KVJUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 04:20:08 -0500
Date: Mon, 22 Nov 2010 10:20:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
Message-ID: <20101122092003.GA21836@basil.fritz.box>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
 <20101122080710.GA1510@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122080710.GA1510@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 09:07:10AM +0100, Ingo Molnar wrote:
> > ---[ High Kernel Mapping ]---
> > ....
> > 0xffffffff81a00000-0xffffffff81c00000           2M     ro         PSE GLB NX pmd
> > 0xffffffff81c00000-0xffffffff81d91000        1604K     ro             GLB NX pte
> > 0xffffffff81d91000-0xffffffff81e00000         444K     ro             GLB NX pte
> > 0xffffffff81e00000-0xffffffff82000000           2M     RW         PSE GLB NX pmd
> > 0xffffffff82000000-0xffffffff8200c000          48K     RW             GLB NX pte
> > 0xffffffff8200c000-0xffffffff82100000         976K     RW             GLB NX pte
> > 0xffffffff82100000-0xffffffff82200000           1M     RW             GLB NX pte
> > .....
> > 
> > The only difference is 0xffffffff81e00000(end) to 0xffffffff82200000(kernel_end) is set to NX.
> > 
> > I guess this range code is used by resume wakeup code. So setting it to NX causes problem.
> > 
> > Any idea?
> 
> Yeah, the resume area is a trampoline, it needs to be executable.

Also it looks like most of the kernel linker supplied data is now not 
2MB mapped anymore? That will surely cost TLB entries.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
