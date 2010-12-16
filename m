Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0LPClw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:41:52 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61631 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754974Ab0LPClv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:41:51 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAsLCU15Lc+z/2dsb2JhbACkM3TBYIVKBA
Date: Thu, 16 Dec 2010 13:41:46 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] include/linux: Add missing include / fix build
 failure
Message-ID: <20101216024146.GA3537@amd>
References: <201012152204.18881.PeterHuewe@gmx.de>
 <20101216103141.6f0a418c.sfr@canb.auug.org.au>
 <201012160040.54313.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201012160040.54313.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for this.

On Thu, Dec 16, 2010 at 12:40:54AM +0100, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a build failure[1-2] by adding the missing asm/memory.h
> include needed for arch_is_coherent().
> 
> Error message:
> In file included from include/linux/list_bl.h:5,
>                  from include/linux/rculist_bl.h:7,
>                  from include/linux/dcache.h:7,
>                  from include/linux/fs.h:381,
>                  from arch/arm/mm/mmap.c:4:
> include/linux/bit_spinlock.h: In function 'bit_spin_unlock':
> include/linux/bit_spinlock.h:61: error: implicit declaration of function 
> 'arch_is_coherent'
> 
> KernelVersion: linux-next-20101215
> Used configs: hackkit_defconfig (arm), ep93xx_defconfig (arm)
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/3651495/
> [2] http://kisskb.ellerman.id.au/kisskb/buildresult/3651425/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> v2:
> moved additional information in the commit message.
> 
>  include/linux/bit_spinlock.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
> index e612575..053fad7 100644
> --- a/include/linux/bit_spinlock.h
> +++ b/include/linux/bit_spinlock.h
> @@ -4,6 +4,7 @@
>  #include <linux/kernel.h>
>  #include <linux/preempt.h>
>  #include <asm/atomic.h>
> +#include <asm/memory.h>
>  
>  /*
>   *  bit-based spin_lock()

The problem is actually in ARM's asm/atomic.h file -- they declare the
smp_mb__before_clear_bit() etc. without providing the necessary includes
to actually call it. Can you include asm/memory.h in there?

Thanks,
Nick

