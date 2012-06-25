Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2FYHon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 03:44:43 -0400
Received: from linux-sh.org ([111.68.239.195]:54624 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab2FYHom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 03:44:42 -0400
Date: Mon, 25 Jun 2012 16:44:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: should there still be arch-specific 4KSTACKS support?
Message-ID: <20120625074436.GC24033@linux-sh.org>
References: <alpine.DEB.2.02.1206231142150.14887@oneiric>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1206231142150.14887@oneiric>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 11:47:33AM -0400, Robert P. J. Day wrote:
> 
>   via some convoluted logic, i ended up doing the following search:
> 
> $ grep -r 4KSTACKS *
> arch/sh/configs/r7785rp_defconfig:CONFIG_4KSTACKS=y
> arch/sh/Kconfig.debug:config 4KSTACKS
> arch/sh/include/asm/thread_info.h:#if defined(CONFIG_4KSTACKS)
> arch/mn10300/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> arch/m68k/Kconfig.machine:config 4KSTACKS
> arch/m68k/configs/m5208evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/configs/m5275evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/configs/m5475evb_defconfig:# CONFIG_4KSTACKS is not set
> arch/m68k/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> arch/c6x/include/asm/thread_info.h:#ifdef CONFIG_4KSTACKS
> drivers/lguest/interrupts_and_traps.c:	 * Depending on the CONFIG_4KSTACKS option, the Guest can have one or
> kernel/lockdep.c:	 * hardirq contexts (such as on 4KSTACKS), so only
> $
> 
>   so even though 4KSTACKS support was officially removed in June of
> 2010:
> 
> $ git show dcfa7262
> 
> there's still traces of it, some of it obviously harmless, leftover
> cruft, but it would appear that both sh and m68k still provide a
> 4KSTACKS config option.
> 
>   how much of that can be tossed as useless?
> 
None. What x86 did with its implementation has no bearing on anyone else.

You can read the following for more information:

	http://lists.linuxfoundation.org/pipermail/ltsi-dev/2012-May/000099.html
