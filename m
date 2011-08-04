Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab1HDVzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 17:55:52 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48237 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753Ab1HDVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 17:55:39 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <paul@pwsan.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCH 2/2] omap_twl: Prevent SR to enable for am3517/am3505 devices
Organization: Texas Instruments, Inc.
References: <1312473569-1212-1-git-send-email-abhilash.kv@ti.com>
Date: Thu, 04 Aug 2011 14:55:35 -0700
In-Reply-To: <1312473569-1212-1-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Thu, 4 Aug 2011 21:29:29 +0530")
Message-ID: <87hb5w3kq0.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> From: Vaibhav Hiremath <hvaibhav@ti.com>
>
> In case of AM3517 & AM3505, Smart Reflex is not applicable so
> we must not enable it. So add check for am3517/05 cpu revision
> in omap3_twl_init() and return -ENODEV if true, else continue.
>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/omap_twl.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_twl.c b/arch/arm/mach-omap2/omap_twl.c
> index 07d6140..92fadcb 100644
> --- a/arch/arm/mach-omap2/omap_twl.c
> +++ b/arch/arm/mach-omap2/omap_twl.c
> @@ -269,6 +269,14 @@ int __init omap3_twl_init(void)
>  	if (!cpu_is_omap34xx())
>  		return -ENODEV;
>  
> +	/*
> +	 * In case of AM3517/AM3505 we should not be going down
> +	 * further, since SR is not applicable there.
> +	 */
> +	if (cpu_is_omap3505() || cpu_is_omap3517()) {
> +		return -ENODEV;
> +	}
> +

Rather than using cpu_is_*, you should add a new "feature" flag for
SmartReflex.  We already have this for things like SGX, IVA, NEON, etc.
See <plat/feature.h>

Kevin


>  	if (cpu_is_omap3630()) {
>  		omap3_mpu_volt_info.vp_vddmin = OMAP3630_VP1_VLIMITTO_VDDMIN;
>  		omap3_mpu_volt_info.vp_vddmax = OMAP3630_VP1_VLIMITTO_VDDMAX;
