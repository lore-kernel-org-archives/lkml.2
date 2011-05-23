Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab1EWH1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:27:46 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:52700 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1EWH1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:27:44 -0400
Date: Mon, 23 May 2011 09:27:40 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCHv2] atomic: add *_dec_not_zero
Message-ID: <20110523072740.GA2377@osiris.boeblingen.de.ibm.com>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
 <1305748194-23351-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305748194-23351-1-git-send-email-sven@narfation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 09:49:54PM +0200, Sven Eckelmann wrote:
> Introduce an *_dec_not_zero operation.  Make this a special case of
> *_add_unless because batman-adv uses atomic_dec_not_zero in different
> places like re-broadcast queue or aggregation queue management. There
> are other non-final patches which may also want to use this macro.
[...]
> ---
> This is actually the same patch as before, but I am still waiting for
> some (N)Acks for ia64, m32r, s390, sh and generic.
[...]
> diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
> index d9db138..09972c3 100644
> --- a/arch/s390/include/asm/atomic.h
> +++ b/arch/s390/include/asm/atomic.h
> @@ -109,6 +109,7 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
>  }
> 
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> +#define atomic_dec_not_zero(v) atomic_add_unless((v), -1, 0)
> 
>  #undef __CS_LOOP
> 
> @@ -326,6 +327,7 @@ static inline long long atomic64_dec_if_positive(atomic64_t *v)
>  #define atomic64_dec_return(_v)		atomic64_sub_return(1, _v)
>  #define atomic64_dec_and_test(_v)	(atomic64_sub_return(1, _v) == 0)
>  #define atomic64_inc_not_zero(v)	atomic64_add_unless((v), 1, 0)
> +#define atomic64_dec_not_zero(v)	atomic64_add_unless((v), -1, 0)
> 
>  #define smp_mb__before_atomic_dec()	smp_mb()
>  #define smp_mb__after_atomic_dec()	smp_mb()

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
