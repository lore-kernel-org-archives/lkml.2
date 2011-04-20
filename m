Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1DTAcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 20:32:24 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:15374 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab1DTAcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 20:32:22 -0400
Message-ID: <4DAE28F6.30805@snapgear.com>
Date: Wed, 20 Apr 2011 10:29:42 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68knommu: use asm-generic/bitops/ext2-atomic.h
References: <1303048649-28265-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1303048649-28265-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 17/04/11 23:57, Akinobu Mita wrote:
> m68knommu can use generic implementation of ext2 atomic bitops.
>
> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Cc: Greg Ungerer<gerg@uclinux.org>

That looks good to me, so:

Acked-by: Greg Ungerer<gerg@uclinux.org>

Do you want me to add it to the m68knommu git tree,
and pass to Linus in the next merge window?

Regards
Greg


> ---
>   arch/m68k/include/asm/bitops_no.h |   18 +-----------------
>   1 files changed, 1 insertions(+), 17 deletions(-)
>
> diff --git a/arch/m68k/include/asm/bitops_no.h b/arch/m68k/include/asm/bitops_no.h
> index 7d3779f..6b0e2d3 100644
> --- a/arch/m68k/include/asm/bitops_no.h
> +++ b/arch/m68k/include/asm/bitops_no.h
> @@ -246,23 +246,7 @@ static inline int __test_and_clear_bit_le(int nr, volatile void *addr)
>   	return retval;
>   }
>
> -#define ext2_set_bit_atomic(lock, nr, addr)		\
> -	({						\
> -		int ret;				\
> -		spin_lock(lock);			\
> -		ret = __test_and_set_bit_le((nr), (addr));	\
> -		spin_unlock(lock);			\
> -		ret;					\
> -	})
> -
> -#define ext2_clear_bit_atomic(lock, nr, addr)		\
> -	({						\
> -		int ret;				\
> -		spin_lock(lock);			\
> -		ret = __test_and_clear_bit_le((nr), (addr));	\
> -		spin_unlock(lock);			\
> -		ret;					\
> -	})
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   static inline int test_bit_le(int nr, const volatile void *addr)
>   {


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
