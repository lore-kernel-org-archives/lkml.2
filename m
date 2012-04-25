Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2DYSDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:03:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44798 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab2DYSDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:03:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120425112244.953956269@chello.nl>
References: <20120425111552.665217867@chello.nl> <20120425112244.953956269@chello.nl>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 25 Apr 2012 11:02:41 -0700
Message-ID: <CALCETrWBMUzG9KYVOQxwCLqnEQjRizz5k4tQW2=emfx1t8TgvA@mail.gmail.com>
Subject: Re: [PATCH 2/2] math128, x86_64: Implement {mult,add}_u128 in 64bit asm
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 4:15 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/include/asm/Kbuild    |    1 -
>  arch/x86/include/asm/math128.h |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 1 deletion(-)

> --- /dev/null
> +++ b/arch/x86/include/asm/math128.h
> @@ -0,0 +1,39 @@
> +#ifndef _ASM_MATH128_H
> +#define _ASM_MATH128_H
> +
> +#ifdef CONFIG_X86_64
> +
> +#ifdef __SIZEOF_INT128__
> +#define ARCH_HAS_INT128
> +#endif
> +
> +#ifndef ARCH_HAS_INT128
> +
> +static inline mul_u64_u64(u64 a, u64 b)

I think you're missing a return type and a 't'.

> +{
> +       u128 res;
> +
> +       asm("mulq %2"
> +               : "=a" (res.lo), "=d" (res.hi)
> +               :  "rm" (b), "0" (a));
> +
> +       return res;
> +}
> +#define mult_u64_u64 mult_u64_u64
> +
> +static inline add_u128(u128 a, u128 b)

Return type here, too.


--Andy
