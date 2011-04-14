Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1DNX7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:59:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:36214 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1DNX7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:59:18 -0400
Message-ID: <4DA78A44.1000704@windriver.com>
Date: Thu, 14 Apr 2011 19:59:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Thunderbird/3.1.9
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc: Define 'crash_kexec_wait_realmode' for Non-SMP
 systems.
References: <20110414222719.GA16256@digium.com>
In-Reply-To: <20110414222719.GA16256@digium.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 14 Apr 2011 23:59:02.0118 (UTC) FILETIME=[EDAAA860:01CBFAFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-04-14 06:27 PM, Shaun Ruffell wrote:
> This fixes a regression from b987812b3fcaf70fdf0037589e5d2f5f2453e6ce

A fix was already sent yesterday:

http://lists.ozlabs.org/pipermail/linuxppc-dev/2011-April/089559.html

which relocates the stub function to where it needs to be.  Your fix
below would end up making duplicate stub functions.

Thanks,
Paul.

> "powerpc/kexec: Fix mismatched ifdefs for PPC64/SMP" which resulted in
> 
> arch/powerpc/kernel/crash.c: In function ‘default_machine_crash_shutdown’:
>   arch/powerpc/kernel/crash.c:349: error: implicit declaration of function
>   ‘crash_kexec_wait_realmode’
> 
> message on when compiling on Blue&White G3 and CONFIG_SMP is not defined.
> 
> Signed-off-by: Shaun Ruffell <sruffell@digium.com>
> ---
>  arch/powerpc/kernel/crash.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
> index 3d3d416..5e6e37f 100644
> --- a/arch/powerpc/kernel/crash.c
> +++ b/arch/powerpc/kernel/crash.c
> @@ -255,6 +255,9 @@ void crash_kexec_secondary(struct pt_regs *regs)
>  {
>  	cpus_in_sr = CPU_MASK_NONE;
>  }
> +
> +static inline void crash_kexec_wait_realmode(int cpu) {}
> +
>  #endif
>  
>  /*
