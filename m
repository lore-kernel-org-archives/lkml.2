Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab1D0JUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 05:20:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55073 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab1D0JT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 05:19:59 -0400
Date: Wed, 27 Apr 2011 10:19:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/6] arm: use asm-generic/bitops/le.h
Message-ID: <20110427091949.GQ17290@n2100.arm.linux.org.uk>
References: <1303824223-3566-1-git-send-email-akinobu.mita@gmail.com> <1303824223-3566-5-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303824223-3566-5-git-send-email-akinobu.mita@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 10:23:41PM +0900, Akinobu Mita wrote:
> The previous style change enables to use asm-generic/bitops/le.h
> on arm.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

> Cc: linux-arm-kernel@lists.infradead.org
> ---
> 
> No change from previous submission
> 
>  arch/arm/include/asm/bitops.h |   43 ++++------------------------------------
>  1 files changed, 5 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
> index 18a024b..b4892a0 100644
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -203,8 +203,6 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
>  #define find_first_bit(p,sz)		_find_first_bit_le(p,sz)
>  #define find_next_bit(p,sz,off)		_find_next_bit_le(p,sz,off)
>  
> -#define WORD_BITOFF_TO_LE(x)		((x))
> -
>  #else
>  /*
>   * These are the big endian, atomic definitions.
> @@ -214,8 +212,6 @@ extern int _find_next_bit_be(const unsigned long *p, int size, int offset);
>  #define find_first_bit(p,sz)		_find_first_bit_be(p,sz)
>  #define find_next_bit(p,sz,off)		_find_next_bit_be(p,sz,off)
>  
> -#define WORD_BITOFF_TO_LE(x)		((x) ^ 0x18)
> -
>  #endif
>  
>  #if __LINUX_ARM_ARCH__ < 5
> @@ -287,40 +283,7 @@ static inline int fls(int x)
>  #include <asm-generic/bitops/hweight.h>
>  #include <asm-generic/bitops/lock.h>
>  
> -static inline void __set_bit_le(int nr, void *addr)
> -{
> -	__set_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline void __clear_bit_le(int nr, void *addr)
> -{
> -	__clear_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline int __test_and_set_bit_le(int nr, void *addr)
> -{
> -	return __test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline int test_and_set_bit_le(int nr, void *addr)
> -{
> -	return test_and_set_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline int __test_and_clear_bit_le(int nr, void *addr)
> -{
> -	return __test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline int test_and_clear_bit_le(int nr, void *addr)
> -{
> -	return test_and_clear_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> -
> -static inline int test_bit_le(int nr, const void *addr)
> -{
> -	return test_bit(WORD_BITOFF_TO_LE(nr), addr);
> -}
> +#ifdef __ARMEB__
>  
>  static inline int find_first_zero_bit_le(const void *p, unsigned size)
>  {
> @@ -340,6 +303,10 @@ static inline int find_next_bit_le(const void *p, int size, int offset)
>  }
>  #define find_next_bit_le find_next_bit_le
>  
> +#endif
> +
> +#include <asm-generic/bitops/le.h>
> +
>  /*
>   * Ext2 is defined to use little-endian byte ordering.
>   */
> -- 
> 1.7.4.4
> 
