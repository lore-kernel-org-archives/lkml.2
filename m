Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab1LHIuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 03:50:07 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46471 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1LHIuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 03:50:03 -0500
Date: Thu, 8 Dec 2011 09:49:58 +0100
From: Borislav Petkov <bp@amd64.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 07/10] cpufreq: Add support for x86 cpuinfo auto loading
Message-ID: <20111208084958.GA23245@gere.osrc.amd.com>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
 <1323304882-27953-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323304882-27953-8-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 04:41:20PM -0800, Andi Kleen wrote:
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index bce576d..069fa86 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -37,6 +37,7 @@
>  #include <linux/delay.h>
>  
>  #include <asm/msr.h>
> +#include <asm/cpu_device_id.h>
>  
>  #include <linux/acpi.h>
>  #include <linux/mutex.h>
> @@ -514,6 +515,20 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
>  	return 0;
>  }
>  
> +static struct x86_cpu_id powernow_k8_ids[] = {
> +	{ X86_VENDOR_AMD, 0xf, },
> +	/* RED-PEN If HW PSTATE was a normal feature bit it could be matched here
> +	 * instead of a (limited) model list.
> +	 */
> +	{ X86_VENDOR_AMD, 0x10, },
> +	{ X86_VENDOR_AMD, 0x11, },
> +	{ X86_VENDOR_AMD, 0x12, },
> +	{ X86_VENDOR_AMD, 0x13, },
> +	{ X86_VENDOR_AMD, 0x14, },
> +	{}

Well, there is CPUID_8000_0007_EDX[7] which denotes the presence
of the P-state registers. It probably could be added to
init_scattered_cpuid_features() but there's still special handling
needed for K8.

Can you do both a family and a feature bit test with the autoprobing
code?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
