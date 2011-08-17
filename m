Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1HQUk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 16:40:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53702 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab1HQUjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 16:39:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 04/36] Hexagon: Add atomic ops support
Date: Wed, 17 Aug 2011 21:20:36 +0200
Message-ID: <1892721.uUY0g5DXJQ@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110817163520.243028227@codeaurora.org>
References: <20110817163457.878854582@codeaurora.org> <20110817163520.243028227@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7XRPvR9ssHOn2YXG6q51bg1o/Z+NQVxhPdXBk8jzLmQ
 kgPXRsIWHfV+jmIKw9RgTZa/1mCORJFbDuVMsqjBIdwNtTRmlu
 +5MEBYX4ggPgFQ5k46m1gwIMpdrK7H5OTP3Tle87+Cr1POe/ey
 DIgTVaRXaHprpYKuzDbYAn/CbgfrvbP4bVD/YYFC9VV902FyS0
 lTclS9kXoE2tjd41GEOfw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011 11:35:01 Richard Kuo wrote:
> +/**
> + * atomic_add_unless - add unless the number is a given value
> + * @v: pointer to value
> + * @a: amount to add
> + * @u: unless value is equal to u
> + *
> + * This is actually in the asm-generic version; should revisit this
> + * entire file...
> + */
> +static inline int __atomic_add_unless(atomic_t *v, int a, int u)
> +{
> +       int c, old;
> +
> +       c = atomic_read(v);
> +       for (;;) {
> +               if (unlikely(c == u))
> +                       break;
> +               old = atomic_cmpxchg((v), c, c + a);
> +               if (likely(old == c))
> +                       break;
> +               c = old;
> +       }
> +       return c != u;
> +}

It's probably worth doing this in a single inline assembly instead
of two nested loops (the second one being inside of atomic_cmpxchg.

	Arnd
