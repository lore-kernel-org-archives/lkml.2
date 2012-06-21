Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab2FUQ3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:29:02 -0400
Received: from mga03.intel.com ([143.182.124.21]:45949 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759741Ab2FUQ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:29:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114722731"
Message-ID: <4FE34BCB.5050305@linux.intel.com>
Date: Thu, 21 Jun 2012 09:28:59 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, cpufeature: Fix duplicate feature name "dts"
References: <20120621162807.3c621d46@endymion.delvare>
In-Reply-To: <20120621162807.3c621d46@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good spotting, but I'm worried this is the wrong fix.

This is a userspace ABI change, and the and we have used "dts" for debug
store (debug trace store?) for a very long tie, whereas digital thermal
sensor only has been used since 2010; another *major* question is which
of these is more likely to be of interest to userspace.

Jan, do you have any feeling on this?

	-hpa


On 06/21/2012 07:28 AM, Jean Delvare wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Subject: x86, cpufeature: Fix duplicate feature name "dts"
> 
> We currently have two different x86 CPU features reported as "dts"
> in /proc/cpuinfo: Debug Store and Digital Thermal Sensor. Change the
> former to "ds" which makes more sense anyway, to clear up the
> confusion.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/cpufeature.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.5-rc3.orig/arch/x86/include/asm/cpufeature.h	2012-06-21 15:57:17.061585016 +0200
> +++ linux-3.5-rc3/arch/x86/include/asm/cpufeature.h	2012-06-21 15:57:42.087585387 +0200
> @@ -35,7 +35,7 @@
>  #define X86_FEATURE_PSE36	(0*32+17) /* 36-bit PSEs */
>  #define X86_FEATURE_PN		(0*32+18) /* Processor serial number */
>  #define X86_FEATURE_CLFLSH	(0*32+19) /* "clflush" CLFLUSH instruction */
> -#define X86_FEATURE_DS		(0*32+21) /* "dts" Debug Store */
> +#define X86_FEATURE_DS		(0*32+21) /* Debug Store */
>  #define X86_FEATURE_ACPI	(0*32+22) /* ACPI via MSR */
>  #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
>  #define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE/FXRSTOR, CR4.OSFXSR */
> 
> 

