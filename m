Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab2DFHqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:46:11 -0400
Received: from claw.goop.org ([74.207.240.146]:55566 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2DFHqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:46:09 -0400
Message-ID: <4F7E9F3E.3050301@goop.org>
Date: Fri, 06 Apr 2012 00:46:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Reitmayr <treitmayr@devbase.at>, leigh123linux@googlemail.com,
        Dave Jones <davej@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Use correct byte-sized register constraint in __xchg_op()
References: <4F7A3315.501@goop.org>
In-Reply-To: <4F7A3315.501@goop.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PIng?

On 04/02/2012 04:15 PM, Jeremy Fitzhardinge wrote:
> x86-64 can access the low half of any register, but i386 can only do
> it with a subset of registers.  'r' causes compilation failures on i386,
> but 'q' expresses the constraint properly.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
> Reported-by: Leigh Scott <leigh123linux@googlemail.com>
> Tested-by: Thomas Reitmayr <treitmayr@devbase.at>
>
> diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
> index b3b7332..bc18d0e 100644
> --- a/arch/x86/include/asm/cmpxchg.h
> +++ b/arch/x86/include/asm/cmpxchg.h
> @@ -43,7 +43,7 @@ extern void __add_wrong_size(void)
>  		switch (sizeof(*(ptr))) {				\
>  		case __X86_CASE_B:					\
>  			asm volatile (lock #op "b %b0, %1\n"		\
> -				      : "+r" (__ret), "+m" (*(ptr))	\
> +				      : "+q" (__ret), "+m" (*(ptr))	\
>  				      : : "memory", "cc");		\
>  			break;						\
>  		case __X86_CASE_W:					\
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

