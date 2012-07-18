Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab2GREeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:34:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:60540 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab2GREeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:34:10 -0400
Message-ID: <1342586037.3669.16.camel@pasglop>
Subject: Re: [PATCH 01/36] atomic64_test: Simplify the #ifdef for
 atomic64_dec_if_positive() test
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>
Date: Wed, 18 Jul 2012 14:33:57 +1000
In-Reply-To: <1341608777-12982-2-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	 <1341608777-12982-2-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-06 at 22:05 +0100, Catalin Marinas wrote:
> This patch introduces ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE and uses this
> instead of the multitude of #if defined() checks in atomic64_test.c
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

I'll let other paint the bike shed as to whether ARCH_HAS_* is the right
thing here, but as far as the powerpc change is concerned:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

> ---
>  arch/arm/include/asm/atomic.h      |    1 +
>  arch/mips/include/asm/atomic.h     |    1 +
>  arch/powerpc/include/asm/atomic.h  |    1 +
>  arch/s390/include/asm/atomic.h     |    1 +
>  arch/x86/include/asm/atomic64_32.h |    1 +
>  arch/x86/include/asm/atomic64_64.h |    1 +
>  lib/atomic64_test.c                |    3 +--
>  7 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index 68374ba..a2f5a44 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -395,6 +395,7 @@ static inline u64 atomic64_xchg(atomic64_t *ptr, u64 new)
>  	return result;
>  }
>  
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  static inline u64 atomic64_dec_if_positive(atomic64_t *v)
>  {
>  	u64 result;
> diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
> index 3f4c5cb..4af30f2 100644
> --- a/arch/mips/include/asm/atomic.h
> +++ b/arch/mips/include/asm/atomic.h
> @@ -736,6 +736,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
>   * atomic64_dec_if_positive - decrement by 1 if old value positive
>   * @v: pointer of type atomic64_t
>   */
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  #define atomic64_dec_if_positive(v)	atomic64_sub_if_positive(1, v)
>  
>  /*
> diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
> index da29032..e235d76 100644
> --- a/arch/powerpc/include/asm/atomic.h
> +++ b/arch/powerpc/include/asm/atomic.h
> @@ -439,6 +439,7 @@ static __inline__ long atomic64_dec_return(atomic64_t *v)
>   * Atomically test *v and decrement if it is greater than 0.
>   * The function returns the old value of *v minus 1.
>   */
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  static __inline__ long atomic64_dec_if_positive(atomic64_t *v)
>  {
>  	long t;
> diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
> index 748347b..dcd174f 100644
> --- a/arch/s390/include/asm/atomic.h
> +++ b/arch/s390/include/asm/atomic.h
> @@ -297,6 +297,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long long a, long long u)
>  	return c != u;
>  }
>  
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  static inline long long atomic64_dec_if_positive(atomic64_t *v)
>  {
>  	long long c, old, dec;
> diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
> index b154de7..4690ce2 100644
> --- a/arch/x86/include/asm/atomic64_32.h
> +++ b/arch/x86/include/asm/atomic64_32.h
> @@ -302,6 +302,7 @@ static inline int atomic64_inc_not_zero(atomic64_t *v)
>  	return r;
>  }
>  
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  static inline long long atomic64_dec_if_positive(atomic64_t *v)
>  {
>  	long long r;
> diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
> index 0e1cbfc..2dd1ae3 100644
> --- a/arch/x86/include/asm/atomic64_64.h
> +++ b/arch/x86/include/asm/atomic64_64.h
> @@ -224,6 +224,7 @@ static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
>   * The function returns the old value of *v minus 1, even if
>   * the atomic variable, v, was not decremented.
>   */
> +#define ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  static inline long atomic64_dec_if_positive(atomic64_t *v)
>  {
>  	long c, old, dec;
> diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
> index cb99b91..4f8429d 100644
> --- a/lib/atomic64_test.c
> +++ b/lib/atomic64_test.c
> @@ -114,8 +114,7 @@ static __init int test_atomic64(void)
>  	r += one;
>  	BUG_ON(v.counter != r);
>  
> -#if defined(CONFIG_X86) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || \
> -    defined(CONFIG_S390) || defined(_ASM_GENERIC_ATOMIC64_H) || defined(CONFIG_ARM)
> +#if defined(ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE) || defined(CONFIG_GENERIC_ATOMIC64)
>  	INIT(onestwos);
>  	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
>  	r -= one;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


