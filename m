Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1LULDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:03:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667Ab1LULD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:03:28 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/8] cpufreq: Add support for x86 cpuinfo auto loading v3
Date: Wed, 21 Dec 2011 12:03:25 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com,
        kay.sievers@vrfy.org
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org> <1324338394-4670-8-git-send-email-andi@firstfloor.org>
In-Reply-To: <1324338394-4670-8-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201112211203.26153.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 20, 2011 12:46:33 AM Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> This marks all the x86 cpuinfo tables to the CPU specific device drivers,
> to allow auto loading by udev. This should simplify the distribution
> startup scripts for this greatly.
> 
> I didn't add MODULE_DEVICE_IDs to the centrino and p4-clockmod drivers,
> because those probably shouldn't be auto loaded and the acpi driver
> be used instead (not fully sure on that, would appreciate feedback)
> 
> The old nforce drivers autoload based on the PCI ID.
> 
> ACPI cpufreq is autoloaded in another patch.
> 
> v3: Autoload gx based on PCI IDs only. Remove cpu check (Dave Jones)
> Cc: davej@redhat.com
> Cc: trenn@suse.de
> Cc: kay.sievers@vrfy.org
> Cc: hpa@zytor.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
...
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index bce576d..c87fabb 100644
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
> @@ -514,6 +515,18 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
>  	return 0;
>  }
>  
> +static const struct x86_cpu_id powernow_k8_ids[] = {
> +	{ X86_VENDOR_AMD, 0xf, },
> +	{ X86_VENDOR_AMD, 0x10, },
> +	{ X86_VENDOR_AMD, 0x11, },
> +	{ X86_VENDOR_AMD, 0x12, },
> +	{ X86_VENDOR_AMD, 0x13, },
> +	{ X86_VENDOR_AMD, 0x14, },
{ X86_VENDOR_AMD, 0x15, },

Should also have BullDozer family included.

> +	/* Add more here? */
> +	{}

    Thomas
