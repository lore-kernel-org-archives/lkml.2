Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab1IVVj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:39:27 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:55653 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab1IVVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:39:23 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, paul@pwsan.com, linux@arm.linux.org.uk,
        b-cousson@ti.com, tony@atomide.com, christian.gmeiner@gmail.com,
        aneesh@ti.com, santosh.shilimkar@ti.com
Subject: Re: [PATCH v4 3/3] OMAP2+: voltage: add check for missing PMIC info in vp init
Organization: Texas Instruments, Inc.
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-2-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-3-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-4-git-send-email-abhilash.kv@ti.com>
Date: Thu, 22 Sep 2011 14:39:17 -0700
In-Reply-To: <1316697993-696-4-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Thu, 22 Sep 2011 18:56:33 +0530")
Message-ID: <87mxdws1dm.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> If PMIC info is not available in omap_vp_init(), abort.
>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

Looks good, some minor nitpicking below...

> ---
>  arch/arm/mach-omap2/vp.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/vp.c b/arch/arm/mach-omap2/vp.c
> index 66bd700..2c99837 100644
> --- a/arch/arm/mach-omap2/vp.c
> +++ b/arch/arm/mach-omap2/vp.c
> @@ -41,6 +41,13 @@ void __init omap_vp_init(struct voltagedomain *voltdm)
>  	u32 val, sys_clk_rate, timeout, waittime;
>  	u32 vddmin, vddmax, vstepmin, vstepmax;
>  
> +	if (!voltdm->pmic || !voltdm->pmic->uv_to_vsel) {
> +		pr_err("%s: PMIC info requried to configure vp for"

nit 1: s/vp/VP/

nit 2: need a space at the end of this string, otherwise the "vdd_" will
be right after the "for" with no spaces.

> +			"vdd_%s not populated.Hence cannot initialize vp\n",

nit 3: Add space after '.'

Kevin

> +			__func__, voltdm->name);
> +		return;
> +	}
> +
>  	if (!voltdm->read || !voltdm->write) {
>  		pr_err("%s: No read/write API for accessing vdd_%s regs\n",
>  			__func__, voltdm->name);
