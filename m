Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1GJADT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 20:03:19 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58702 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755089Ab1GJADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 20:03:17 -0400
Message-ID: <4E18EC41.2080102@ti.com>
Date: Sat, 09 Jul 2011 17:03:13 -0700
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>, Russell King <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH] ARM: gic: Allow gic arch extensions to provide irqchip
 flags
References: <1307925960-28839-1-git-send-email-ccross@android.com>
In-Reply-To: <1307925960-28839-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/12/2011 5:45 PM, Colin Cross wrote:
> Tegra can benefit from the IRQCHIP_MASK_ON_SUSPEND flag, allow it
> to be passed to the gic irq chip.
>
> Signed-off-by: Colin Cross<ccross@android.com>

I missed this patch. Looks good to me and I think can
be merged in rc as well.
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

> ---
>   arch/arm/common/gic.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
> index 8d62e07..a6c28a0 100644
> --- a/arch/arm/common/gic.c
> +++ b/arch/arm/common/gic.c
> @@ -576,6 +576,7 @@ void __init gic_init(unsigned int gic_nr, unsigned int irq_start,
>   	if (gic_nr == 0)
>   		gic_cpu_base_addr = cpu_base;
>
> +	gic_chip.flags |= gic_arch_extn.flags;
>   	gic_dist_init(gic, irq_start);
>   	gic_cpu_init(gic);
>   	gic_cpu_pm_init(gic);

Russell,
Any thoughts on this fix?

Regards
Santosh
