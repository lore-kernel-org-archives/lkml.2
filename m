Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab1EQB5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 21:57:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1EQB5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 21:57:39 -0400
Message-ID: <4DD1D5EB.3070602@zytor.com>
Date: Mon, 16 May 2011 18:56:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] x86, cpu: Add CPU flags for SMEP
References: <1305581685-5144-1-git-send-email-fenghua.yu@intel.com> <1305581685-5144-2-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1305581685-5144-2-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 02:34 PM, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Add support for newly documented SMEP (Supervisor Mode Execution Protection) CPU
> feature flags.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h |    1 +
>  arch/x86/kernel/cpu/scattered.c   |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 50c0d30..e773f13 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -174,6 +174,7 @@
>  #define X86_FEATURE_PLN		(7*32+ 5) /* Intel Power Limit Notification */
>  #define X86_FEATURE_PTS		(7*32+ 6) /* Intel Package Thermal Status */
>  #define X86_FEATURE_DTS		(7*32+ 7) /* Digital Thermal Sensor */
> +#define X86_FEATURE_SMEP	(7*32+ 8) /* Supervisor Mode Execution Protection*/
>  
>  /* Virtualization flags: Linux defined, word 8 */
>  #define X86_FEATURE_TPR_SHADOW  (8*32+ 0) /* Intel TPR Shadow */
> diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
> index c7f64e6..2de3aea 100644
> --- a/arch/x86/kernel/cpu/scattered.c
> +++ b/arch/x86/kernel/cpu/scattered.c
> @@ -38,6 +38,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
>  		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
>  		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
>  		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
> +		{ X86_FEATURE_SMEP,		CR_EBX, 7, 0x00000007, 0 },
>  		{ X86_FEATURE_XSAVEOPT,		CR_EAX,	0, 0x0000000d, 1 },
>  		{ X86_FEATURE_CPB,		CR_EDX, 9, 0x80000007, 0 },
>  		{ X86_FEATURE_NPT,		CR_EDX, 0, 0x8000000a, 0 },

The level 7 flags are not considered "scattered"; they have their own
word; please use it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

