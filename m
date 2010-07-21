Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175Ab0GUSQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 14:16:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:51172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab0GUSQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 14:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,239,1278313200"; 
   d="scan'208";a="640486984"
Subject: Re: [PATCH 6/7] x86, xsave: disable xsave in i387 emulation mode
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1279731838-1522-7-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
	 <1279731838-1522-7-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 21 Jul 2010 11:16:02 -0700
Message-Id: <1279736162.2812.3.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 10:03 -0700, Robert Richter wrote:
> xsave is broken for (!HAVE_HWFP). This is the case if config
> MATH_EMULATION is enabled, 'no387' kernel parameter is set and xsave
> exists. xsave will not work because x86/math-emu and xsave share the
> same memory. As this case can be treated as corner case we simply
> disable xsave then.

I think it is cleaner to clear these cpu capabilities in the function
which handles no387 boot parameter.

Otherwise Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

thanks.

> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/i387.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index e73c54e..ff81143 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -67,6 +67,12 @@ static void __cpuinit init_thread_xstate(void)
>  	 */
>  
>  	if (!HAVE_HWFP) {
> +		/*
> +		 * Disable xsave as we do not support it if i387
> +		 * emulation is enabled.
> +		 */
> +		setup_clear_cpu_cap(X86_FEATURE_XSAVE);
> +		setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
>  		xstate_size = sizeof(struct i387_soft_struct);
>  		return;
>  	}

