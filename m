Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab2IGHQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:16:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55752 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab2IGHQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:16:40 -0400
Message-ID: <50499F3C.1070706@zytor.com>
Date: Fri, 07 Sep 2012 00:16:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ix86: improve determination of X86_MINIMUM_CPU_FAMILY
References: <5049B4C102000078000998FE@nat28.tlf.novell.com>
In-Reply-To: <5049B4C102000078000998FE@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 11:48 PM, Jan Beulich wrote:
>
> --- 3.6-rc4/arch/x86/Kconfig.cpu
> +++ 3.6-rc4-x86-minimum-cpu-family/arch/x86/Kconfig.cpu
> @@ -409,9 +409,9 @@ config X86_CMOV
>   config X86_MINIMUM_CPU_FAMILY
>   	int
>   	default "64" if X86_64
> -	default "6" if X86_32 && X86_P6_NOP
> -	default "5" if X86_32 && X86_CMPXCHG64
> -	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
> +	default "6" if X86_P6_NOP || X86_CMOV
> +	default "5" if X86_CMPXCHG64 || X86_TSC
> +	default "4" if X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK
>   	default "3"
>

Erk, this isn't right either.  We're not supposed to include 
CPUID-enumerable features here, so X86_CMOV, X86_CMPXCHG64 and X86_TSC 
don't belong, and should instead be done via required-features.h.

What a mess.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

