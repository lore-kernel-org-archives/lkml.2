Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab1I3Slq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:41:46 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56613 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1I3Slp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:41:45 -0400
Date: Fri, 30 Sep 2011 12:41:44 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Abhilash K V <abhilash.kv@ti.com>
cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        b-cousson@ti.com, aneesh@ti.com, khilman@ti.com,
        santosh.shilimkar@ti.com, christian.gmeiner@gmail.com
Subject: Re: [PATCH v5 3/3] OMAP2+: voltage: add check for missing PMIC info
 in vp init
In-Reply-To: <1317363153-10259-4-git-send-email-abhilash.kv@ti.com>
Message-ID: <alpine.DEB.2.00.1109301240070.12185@utopia.booyaka.com>
References: <1317363153-10259-1-git-send-email-abhilash.kv@ti.com> <1317363153-10259-2-git-send-email-abhilash.kv@ti.com> <1317363153-10259-3-git-send-email-abhilash.kv@ti.com> <1317363153-10259-4-git-send-email-abhilash.kv@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, 30 Sep 2011, Abhilash K V wrote:

> From: Abhilash K V <abhilash.kv@ti.com>
> 
> If PMIC info is not available in omap_vp_init(), abort.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/vp.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/vp.c b/arch/arm/mach-omap2/vp.c
> index 66bd700..0ed3d13 100644
> --- a/arch/arm/mach-omap2/vp.c
> +++ b/arch/arm/mach-omap2/vp.c
> @@ -41,6 +41,13 @@ void __init omap_vp_init(struct voltagedomain *voltdm)
>  	u32 val, sys_clk_rate, timeout, waittime;
>  	u32 vddmin, vddmax, vstepmin, vstepmax;
>  
> +	if (!voltdm->pmic || !voltdm->pmic->uv_to_vsel) {
> +		pr_err("%s: PMIC info requried to configure VP for "
> +			"vdd_%s not populated.Hence cannot initialize VP\n",
> +			__func__, voltdm->name);
> +		return;
> +	}
> +

Just wondering about the intent of this patch.  Is the goal here to not 
call omap_vp_init() for chips that don't have a VP IP block?  If so, then 
implementing code that does that directly seems like a better approach 
than using the PMIC data?  Because it seems likely that even SoCs without 
VP IP blocks will have PMICs on the board, right?


- Paul
