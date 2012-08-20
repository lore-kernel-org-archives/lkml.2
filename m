Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab2HTJPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:15:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab2HTJPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:15:33 -0400
Message-ID: <50320027.1010809@redhat.com>
Date: Mon, 20 Aug 2012 12:15:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight optimizations for
 LTO
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-47-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-47-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 05:56 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The fancy x86 hweight uses different compiler options for the
> hweight file. This does not work with LTO. Just disable the optimization
> with LTO
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/Kconfig                    |    5 +++--
>  arch/x86/include/asm/arch_hweight.h |    9 +++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 8ec3a1a..9382b09 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -224,8 +224,9 @@ config X86_32_LAZY_GS
>  
>  config ARCH_HWEIGHT_CFLAGS
>  	string
> -	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
> -	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
> +	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32 && !LTO
> +	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64 && !LTO
> +	default "" if LTO
>  

Seems heavy handed.  How about using __attribute__((optimize(...))) instead?


-- 
error compiling committee.c: too many arguments to function
