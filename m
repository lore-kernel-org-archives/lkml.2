Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2HCSdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 14:33:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40240 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab2HCSdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 14:33:09 -0400
Message-ID: <501C1953.8020807@zytor.com>
Date: Fri, 03 Aug 2012 11:32:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Alex Shi <alex.shi@intel.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/4] x86, CPU: Extend TLB size detection for AMD
References: <1344011869-21868-1-git-send-email-bp@amd64.org> <1344011869-21868-3-git-send-email-bp@amd64.org>
In-Reply-To: <1344011869-21868-3-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 09:37 AM, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> TLB characteristics on AMD are in the extended CPUID level, leafs
> 0x8000000{5,6} so we need to check those before doing the detection.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index d239977f361f..ebab0e77e691 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -940,7 +940,8 @@ void __init identify_boot_cpu(void)
>  #else
>  	vgetcpu_set_mode();
>  #endif
> -	if (boot_cpu_data.cpuid_level >= 2)
> +	if (boot_cpu_data.cpuid_level >= 2 ||
> +	    boot_cpu_data.extended_cpuid_level >= 0x80000006)
>  		cpu_detect_tlb(&boot_cpu_data);
>  }
>  

This really belongs in cpu_detect_tlb() itself (or rather, in the
subfunctions called by it.)  Can we just lose the general test here, please?

	-hpa

