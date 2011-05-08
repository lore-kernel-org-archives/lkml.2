Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1EHXTE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 19:19:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:52931 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1EHXTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 19:19:00 -0400
Subject: Re: [PATCH] atomic: add *_dec_not_zero
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-m32r@ml.linux-m32r.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, x86@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 08:15:39 +1000
Message-ID: <1304892939.2513.503.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 23:30 +0200, Sven Eckelmann wrote:
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.

For arch/powerpc:

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

(Sorry for catching up late)

Cheers,
Ben.

> diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
> index b8f152e..906f49a 100644
> --- a/arch/powerpc/include/asm/atomic.h
> +++ b/arch/powerpc/include/asm/atomic.h
> @@ -213,6 +213,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
>  }
>  
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> +#define atomic_dec_not_zero(v) atomic_add_unless((v), -1, 0)
>  
>  #define atomic_sub_and_test(a, v)	(atomic_sub_return((a), (v)) == 0)
>  #define atomic_dec_and_test(v)		(atomic_dec_return((v)) == 0)
> @@ -469,6 +470,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
>  }
>  
>  #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +#define atomic64_dec_not_zero(v) atomic64_add_unless((v), -1, 0)
>  
>  #else  /* __powerpc64__ */
>  #include <asm-generic/atomic64.h>
> diff --git a/arch/powerpc/include/asm/local.h b/arch/powerpc/include/asm/local.h
> index c2410af..3d4c58a 100644
> --- a/arch/powerpc/include/asm/local.h
> +++ b/arch/powerpc/include/asm/local.h
> @@ -134,6 +134,7 @@ static __inline__ int local_add_unless(local_t *l, long a, long u)
>  }
>  
>  #define local_inc_not_zero(l) local_add_unless((l), 1, 0)
> +#define local_dec_not_zero(l) local_add_unless((l), -1, 0)
>  
>  #define local_sub_and_test(a, l)	(local_sub_return((a), (l)) == 0)
>  #define local_dec_and_test(l)		(local_dec_return((l)) == 0)



