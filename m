Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab0GTWXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 18:23:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:63234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932736Ab0GTWXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 18:23:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="588121099"
Subject: Re: [PATCH 07/10] x86, xsave: reduce cpu_has_xsave checks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-8-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-8-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 15:22:26 -0700
Message-Id: <1279664546.2899.50.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> This moves the cpu_has_xsave check at the beginning of
> xsave_init(). All other checks may removed then.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> ---
>  arch/x86/kernel/xsave.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
> index a594f49..550bf45 100644
> --- a/arch/x86/kernel/xsave.c
> +++ b/arch/x86/kernel/xsave.c
> @@ -362,9 +362,6 @@ unsigned int sig_xstate_size = sizeof(struct _fpstate);
>   */
>  static void __cpuinit __xsave_init(void)
>  {
> -	if (!cpu_has_xsave)
> -		return;
> -
>  	set_in_cr4(X86_CR4_OSXSAVE);
>  
>  	/*
> @@ -433,9 +430,6 @@ static void __cpuinit xsave_cntxt_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
>  
> -	if (!cpu_has_xsave)
> -		return;
> -
>  	cpuid_count(0xd, 0, &eax, &ebx, &ecx, &edx);
>  	pcntxt_mask = eax + ((u64)edx << 32);
>  
> @@ -469,6 +463,9 @@ static void __cpuinit xsave_cntxt_init(void)
>  
>  void __cpuinit xsave_init(void)
>  {
> +	if (!cpu_has_xsave)
> +		return;
> +
>  	/*
>  	 * Boot processor to setup the FP and extended state context info.
>  	 */

