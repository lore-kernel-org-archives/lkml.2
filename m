Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1EDSNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 14:13:53 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49500 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1EDSNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 14:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cYOJce8VpG868iJ0yzmRyAszW2Fl48ey7hvbXiW1SagCtjGsRA/MsLC5sr2D1GrN6v
         lY33gIN+ZbD4ljGMpWkvClkczjGlXLdRGW1Dtor7c1IGCIIYb1PQCYhK740p+hMGXtpC
         Ui6Z6P0EW941i+Z0I0Bn1ZACrUf7hqyjuNYuQ=
MIME-Version: 1.0
In-Reply-To: <1304458235-28473-1-git-send-email-sven@narfation.org>
References: <1304458235-28473-1-git-send-email-sven@narfation.org>
From: Matt Turner <mattst88@gmail.com>
Date: Wed, 4 May 2011 14:13:29 -0400
Message-ID: <BANLkTinWa9E1_iLWyqAF+G8Qag=YK2T98A@mail.gmail.com>
Subject: Re: [PATCH] atomic: add *_dec_not_zero
To: Sven Eckelmann <sven@narfation.org>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, x86@kernel.org,
        linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-cris-kernel@axis.com,
        linux-ia64@vger.kernel.org, linux-m32r@ml.linux-m32r.org,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-am33-list@redhat.com, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 3, 2011 at 5:30 PM, Sven Eckelmann <sven@narfation.org> wrote:
> diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
> index e756d04..7e9434e 100644
> --- a/arch/alpha/include/asm/atomic.h
> +++ b/arch/alpha/include/asm/atomic.h
> @@ -200,6 +200,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
>  }
>
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> +#define atomic_dec_not_zero(v) atomic_add_unless((v), -1, 0)
>
>  /**
>  * atomic64_add_unless - add unless the number is a given value
> @@ -226,6 +227,7 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
>  }
>
>  #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
> +#define atomic64_dec_not_zero(v) atomic64_add_unless((v), -1, 0)
>
>  #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
>  #define atomic64_add_negative(a, v) (atomic64_add_return((a), (v)) < 0)
> diff --git a/arch/alpha/include/asm/local.h b/arch/alpha/include/asm/local.h
> index b9e3e33..09fb327 100644
> --- a/arch/alpha/include/asm/local.h
> +++ b/arch/alpha/include/asm/local.h
> @@ -79,6 +79,7 @@ static __inline__ long local_sub_return(long i, local_t * l)
>        c != (u);                                               \
>  })
>  #define local_inc_not_zero(l) local_add_unless((l), 1, 0)
> +#define local_dec_not_zero(l) local_add_unless((l), -1, 0)
>
>  #define local_add_negative(a, l) (local_add_return((a), (l)) < 0)
>

Acked-by: Matt Turner <mattst88@gmail.com> [alpha]
