Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0GTVsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 17:48:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:54748 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab0GTVsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 17:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,234,1278313200"; 
   d="scan'208";a="588113251"
Subject: Re: [PATCH 02/10] x86, xsave: 32/64 bit boot cpu check unification
 in initialization
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279651857-24639-3-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
	 <1279651857-24639-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 20 Jul 2010 14:47:40 -0700
Message-Id: <1279662460.2899.15.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 11:50 -0700, Robert Richter wrote:
> Boot cpu id is always 0, thus simplifying and unifying boot cpu check.
> 
> boot_cpu_id is there for historical reasons and was renamed to
> boot_cpu_physical_apicid in patch:
> 
>  c70dcb7 x86: change boot_cpu_id to boot_cpu_physical_apicid
> 
> However, there are some remaining occurrences of boot_cpu_id that are
> never touched in the kernel and thus its value is always 0.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 3f715ef..26804b2 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1273,7 +1273,7 @@ void __cpuinit cpu_init(void)
>  	/*
>  	 * Boot processor to setup the FP and extended state context info.
>  	 */
> -	if (smp_processor_id() == boot_cpu_id)
> +	if (!smp_processor_id())
>  		init_thread_xstate();
>  
>  	xsave_init();

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

