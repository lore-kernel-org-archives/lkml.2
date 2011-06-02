Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab1FBEaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 00:30:23 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:59674 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab1FBEaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 00:30:21 -0400
Message-ID: <4DE711DE.5050603@snapgear.com>
Date: Thu, 2 Jun 2011 14:30:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] asm-generic: add another generic ext2 atomic bitops
References: <1306938736-11119-1-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1306938736-11119-1-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Akinobu,

On 02/06/11 00:32, Akinobu Mita wrote:
> The majority of architectures implement ext2 atomic bitops as
> test_and_{set,clear}_bit() without spinlock.
>
> This adds this type of generic implementation in ext2-atomic.h and
> use it wherever possible.

I am trying to get consensus on merging the m68k bitops_mm.h and
bitops_no.h. Here is a proposed patch to do this:

http://www.spinics.net/lists/linux-m68k/msg03803.html

I expect you wouldn't need to patch m68k/bitops_mm.h if this
goes in.

Regards
Greg



> Suggested-by: Andreas Dilger<adilger@dilger.ca>
> Signed-off-by: Akinobu Mita<akinobu.mita@gmail.com>
> Cc: Arnd Bergmann<arnd@arndb.de>
> Cc: linux-arch@vger.kernel.org
> ---
>   arch/alpha/include/asm/bitops.h          |    4 ++--
>   arch/arm/include/asm/bitops.h            |    6 ++----
>   arch/cris/include/asm/bitops.h           |    4 ++--
>   arch/frv/include/asm/bitops.h            |    4 ++--
>   arch/ia64/include/asm/bitops.h           |    4 ++--
>   arch/m68k/include/asm/bitops_mm.h        |    6 ++----
>   arch/mn10300/include/asm/bitops.h        |    8 ++------
>   arch/parisc/include/asm/bitops.h         |   10 ++--------
>   arch/powerpc/include/asm/bitops.h        |    6 ++----
>   arch/s390/include/asm/bitops.h           |    6 ++----
>   arch/sparc/include/asm/bitops_64.h       |    6 ++----
>   arch/tile/include/asm/bitops_64.h        |    6 ++----
>   arch/x86/include/asm/bitops.h            |    6 ++----
>   arch/xtensa/include/asm/bitops.h         |   15 ++-------------
>   include/asm-generic/bitops/ext2-atomic.h |    9 +++++++++
>   15 files changed, 37 insertions(+), 63 deletions(-)
>
> diff --git a/arch/alpha/include/asm/bitops.h b/arch/alpha/include/asm/bitops.h
> index 85b8152..e7f02c6 100644
> --- a/arch/alpha/include/asm/bitops.h
> +++ b/arch/alpha/include/asm/bitops.h
> @@ -456,8 +456,8 @@ sched_find_first_bit(const unsigned long b[2])
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
> -#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>
> diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
> index b4892a0..5720428 100644
> --- a/arch/arm/include/asm/bitops.h
> +++ b/arch/arm/include/asm/bitops.h
> @@ -310,10 +310,8 @@ static inline int find_next_bit_le(const void *p, int size, int offset)
>   /*
>    * Ext2 is defined to use little-endian byte ordering.
>    */
> -#define ext2_set_bit_atomic(lock, nr, p)	\
> -		test_and_set_bit_le(nr, p)
> -#define ext2_clear_bit_atomic(lock, nr, p)	\
> -		test_and_clear_bit_le(nr, p)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>
> diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
> index 310e0de..5388ebf 100644
> --- a/arch/cris/include/asm/bitops.h
> +++ b/arch/cris/include/asm/bitops.h
> @@ -156,8 +156,8 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(l,n,a)   test_and_set_bit(n,a)
> -#define ext2_clear_bit_atomic(l,n,a) test_and_clear_bit(n,a)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #include<asm-generic/bitops/sched.h>
>
> diff --git a/arch/frv/include/asm/bitops.h b/arch/frv/include/asm/bitops.h
> index a1d00b0..d0bde35 100644
> --- a/arch/frv/include/asm/bitops.h
> +++ b/arch/frv/include/asm/bitops.h
> @@ -403,8 +403,8 @@ int __ilog2_u64(u64 n)
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(lock,nr,addr)	test_and_set_bit  ((nr) ^ 0x18, (addr))
> -#define ext2_clear_bit_atomic(lock,nr,addr)	test_and_clear_bit((nr) ^ 0x18, (addr))
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>
> diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
> index b76f7e0..6d7b4d8 100644
> --- a/arch/ia64/include/asm/bitops.h
> +++ b/arch/ia64/include/asm/bitops.h
> @@ -458,8 +458,8 @@ static __inline__ unsigned long __arch_hweight64(unsigned long x)
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(l,n,a)	test_and_set_bit(n,a)
> -#define ext2_clear_bit_atomic(l,n,a)	test_and_clear_bit(n,a)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #include<asm-generic/bitops/sched.h>
>
> diff --git a/arch/m68k/include/asm/bitops_mm.h b/arch/m68k/include/asm/bitops_mm.h
> index 89cf5b8..2514ad7 100644
> --- a/arch/m68k/include/asm/bitops_mm.h
> +++ b/arch/m68k/include/asm/bitops_mm.h
> @@ -491,10 +491,8 @@ static inline unsigned long find_next_bit_le(const void *addr,
>
>   /* Bitmap functions for the ext2 filesystem. */
>
> -#define ext2_set_bit_atomic(lock, nr, addr)	\
> -	test_and_set_bit_le(nr, addr)
> -#define ext2_clear_bit_atomic(lock, nr, addr)	\
> -	test_and_clear_bit_le(nr, addr)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>
> diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
> index 0939462..d42ba8e 100644
> --- a/arch/mn10300/include/asm/bitops.h
> +++ b/arch/mn10300/include/asm/bitops.h
> @@ -227,12 +227,8 @@ int ffs(int x)
>   #include<asm-generic/bitops/find.h>
>   #include<asm-generic/bitops/sched.h>
>   #include<asm-generic/bitops/hweight.h>
> -
> -#define ext2_set_bit_atomic(lock, nr, addr) \
> -	test_and_set_bit((nr), (addr))
> -#define ext2_clear_bit_atomic(lock, nr, addr) \
> -	test_and_clear_bit((nr), (addr))
> -
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>   #include<asm-generic/bitops/le.h>
>
>   #endif /* __KERNEL__ */
> diff --git a/arch/parisc/include/asm/bitops.h b/arch/parisc/include/asm/bitops.h
> index 43c516f..e9a5bc9 100644
> --- a/arch/parisc/include/asm/bitops.h
> +++ b/arch/parisc/include/asm/bitops.h
> @@ -223,14 +223,8 @@ static __inline__ int fls(int x)
>   #ifdef __KERNEL__
>
>   #include<asm-generic/bitops/le.h>
> -
> -/* '3' is bits per byte */
> -#define LE_BYTE_ADDR ((sizeof(unsigned long) - 1)<<  3)
> -
> -#define ext2_set_bit_atomic(l,nr,addr) \
> -		test_and_set_bit((nr)   ^ LE_BYTE_ADDR, (unsigned long *)addr)
> -#define ext2_clear_bit_atomic(l,nr,addr) \
> -		test_and_clear_bit( (nr) ^ LE_BYTE_ADDR, (unsigned long *)addr)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif	/* __KERNEL__ */
>
> diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
> index f18c6d9..9fb8f9d 100644
> --- a/arch/powerpc/include/asm/bitops.h
> +++ b/arch/powerpc/include/asm/bitops.h
> @@ -327,10 +327,8 @@ unsigned long find_next_bit_le(const void *addr,
>   				    unsigned long size, unsigned long offset);
>   /* Bitmap functions for the ext2 filesystem */
>
> -#define ext2_set_bit_atomic(lock, nr, addr) \
> -	test_and_set_bit_le((nr), (unsigned long*)addr)
> -#define ext2_clear_bit_atomic(lock, nr, addr) \
> -	test_and_clear_bit_le((nr), (unsigned long*)addr)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #include<asm-generic/bitops/sched.h>
>
> diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
> index 667c6e9..5f60712 100644
> --- a/arch/s390/include/asm/bitops.h
> +++ b/arch/s390/include/asm/bitops.h
> @@ -832,10 +832,8 @@ static inline int find_next_bit_le(void *vaddr, unsigned long size,
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(lock, nr, addr)	\
> -	test_and_set_bit_le(nr, addr)
> -#define ext2_clear_bit_atomic(lock, nr, addr)	\
> -	test_and_clear_bit_le(nr, addr)
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>
>   #endif /* __KERNEL__ */
> diff --git a/arch/sparc/include/asm/bitops_64.h b/arch/sparc/include/asm/bitops_64.h
> index 38e9aa1..e67166c 100644
> --- a/arch/sparc/include/asm/bitops_64.h
> +++ b/arch/sparc/include/asm/bitops_64.h
> @@ -91,10 +91,8 @@ static inline unsigned int __arch_hweight8(unsigned int w)
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(lock,nr,addr) \
> -	test_and_set_bit((nr) ^ 0x38,(unsigned long *)(addr))
> -#define ext2_clear_bit_atomic(lock,nr,addr) \
> -	test_and_clear_bit((nr) ^ 0x38,(unsigned long *)(addr))
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>
> diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
> index 99615e8..ce6ec72 100644
> --- a/arch/tile/include/asm/bitops_64.h
> +++ b/arch/tile/include/asm/bitops_64.h
> @@ -97,9 +97,7 @@ static inline int test_and_change_bit(unsigned nr,
>   	return (oldval&  mask) != 0;
>   }
>
> -#define ext2_set_bit_atomic(lock, nr, addr)			\
> -	test_and_set_bit((nr), (unsigned long *)(addr))
> -#define ext2_clear_bit_atomic(lock, nr, addr)			\
> -	test_and_clear_bit((nr), (unsigned long *)(addr))
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* _ASM_TILE_BITOPS_64_H */
> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 69d5813..abe730f 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -458,10 +458,8 @@ static inline int fls(int x)
>
>   #include<asm-generic/bitops/le.h>
>
> -#define ext2_set_bit_atomic(lock, nr, addr)			\
> -	test_and_set_bit((nr), (unsigned long *)(addr))
> -#define ext2_clear_bit_atomic(lock, nr, addr)			\
> -	test_and_clear_bit((nr), (unsigned long *)(addr))
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #endif /* __KERNEL__ */
>   #endif /* _ASM_X86_BITOPS_H */
> diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
> index c8fac8d..f948187 100644
> --- a/arch/xtensa/include/asm/bitops.h
> +++ b/arch/xtensa/include/asm/bitops.h
> @@ -108,19 +108,8 @@ static inline unsigned long __fls(unsigned long word)
>   #include<asm-generic/bitops/find.h>
>   #include<asm-generic/bitops/le.h>
>
> -#ifdef __XTENSA_EL__
> -# define ext2_set_bit_atomic(lock,nr,addr)				\
> -	test_and_set_bit((nr), (unsigned long*)(addr))
> -# define ext2_clear_bit_atomic(lock,nr,addr)				\
> -	test_and_clear_bit((nr), (unsigned long*)(addr))
> -#elif defined(__XTENSA_EB__)
> -# define ext2_set_bit_atomic(lock,nr,addr)				\
> -	test_and_set_bit((nr) ^ 0x18, (unsigned long*)(addr))
> -# define ext2_clear_bit_atomic(lock,nr,addr)				\
> -	test_and_clear_bit((nr) ^ 0x18, (unsigned long*)(addr))
> -#else
> -# error processor byte order undefined!
> -#endif
> +#define ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +#include<asm-generic/bitops/ext2-atomic.h>
>
>   #include<asm-generic/bitops/hweight.h>
>   #include<asm-generic/bitops/lock.h>
> diff --git a/include/asm-generic/bitops/ext2-atomic.h b/include/asm-generic/bitops/ext2-atomic.h
> index ecf1c9d..315760b 100644
> --- a/include/asm-generic/bitops/ext2-atomic.h
> +++ b/include/asm-generic/bitops/ext2-atomic.h
> @@ -1,6 +1,13 @@
>   #ifndef _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
>   #define _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_
>
> +#ifdef ARCH_NO_EXT2_ATOMIC_SPINLOCK
> +
> +#define ext2_set_bit_atomic(l, nr, addr)	test_and_set_bit_le(nr, addr)
> +#define ext2_clear_bit_atomic(l, nr, addr)	test_and_clear_bit_le(nr, addr)
> +
> +#else
> +
>   #define ext2_set_bit_atomic(lock, nr, addr)		\
>   	({						\
>   		int ret;				\
> @@ -19,4 +26,6 @@
>   		ret;					\
>   	})
>
> +#endif
> +
>   #endif /* _ASM_GENERIC_BITOPS_EXT2_ATOMIC_H_ */


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
