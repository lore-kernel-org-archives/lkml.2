Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1ADGbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 01:31:19 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58454 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1ADGbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 01:31:18 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFBMIk15Ldpx/2dsb2JhbACkNXS7SIVKBJEW
Date: Tue, 4 Jan 2011 17:30:50 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Huewe <PeterHuewe@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH RESEND] [ARM] Add missing include "asm/memory.h"
Message-ID: <20110104063050.GE3402@amd>
References: <1293501397.32542.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293501397.32542.2.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 28, 2010 at 09:56:37AM +0800, Axel Lin wrote:
> This patch fixes below build error by adding the missing asm/memory.h,
> which is needed for arch_is_coherent().

This is the right approach, but needs to go through ARM tree.
 

> $ make pxa3xx_defconfig; make
>   CC      init/do_mounts_rd.o
> In file included from include/linux/list_bl.h:5,
>                  from include/linux/rculist_bl.h:7,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:381,
>                  from init/do_mounts_rd.c:3:
> include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
> include/linux/bit_spinlock.h:61: error: implicit declaration of function 'arch_is_coherent'
> make[1]: *** [init/do_mounts_rd.o] Error 1
> make: *** [init] Error 2
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> It was posted on https://lkml.org/lkml/2010/12/17/9 .
> I still have the build error for today's linux-next tree.
> CC Eric Miao, maybe he will take this patch.
> 
> Axel
> 
>  arch/arm/include/asm/system.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> index ec4327a..3222ab8 100644
> --- a/arch/arm/include/asm/system.h
> +++ b/arch/arm/include/asm/system.h
> @@ -155,6 +155,7 @@ extern unsigned int user_debug;
>  #define rmb()		dmb()
>  #define wmb()		mb()
>  #else
> +#include <asm/memory.h>
>  #define mb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
>  #define rmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
>  #define wmb()	do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)

Is this matching ARM convention to pull includes down here. It
usually ends up with more elusive dependency problems and strange
bugs (eg. some headers define intermediate symbols for convenience
and then undef them sometime later etc etc). Usual thing to avoid
problems is to move includes up to the top.

