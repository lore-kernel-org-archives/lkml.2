Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1EHJYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 05:24:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49168 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1EHJYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 05:24:32 -0400
Date: Sun, 8 May 2011 10:24:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Subject: Re: [PATCH] atomic: add *_dec_not_zero
Message-ID: <20110508092403.GB27807@n2100.arm.linux.org.uk>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 11:30:35PM +0200, Sven Eckelmann wrote:
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.
...
> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index 7e79503..a005265 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -218,6 +218,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
>  	return c != u;
>  }
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> +#define atomic_dec_not_zero(v) atomic_add_unless((v), -1, 0)
>  
>  #define atomic_inc(v)		atomic_add(1, v)
>  #define atomic_dec(v)		atomic_sub(1, v)
> @@ -459,6 +460,7 @@ static inline int atomic64_add_unless(atomic64_t *v, u64 a, u64 u)
>  #define atomic64_dec_return(v)		atomic64_sub_return(1LL, (v))
>  #define atomic64_dec_and_test(v)	(atomic64_dec_return((v)) == 0)
>  #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1LL, 0LL)
> +#define atomic64_dec_not_zero(v)	atomic64_add_unless((v), -1LL, 0LL)
>  
>  #else /* !CONFIG_GENERIC_ATOMIC64 */
>  #include <asm-generic/atomic64.h>

Do we need atomic_dec_not_zero() et.al. in every arch header - is there no
generic header which it could be added to?
