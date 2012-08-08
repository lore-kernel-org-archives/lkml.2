Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab2HHEHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 00:07:24 -0400
Received: from void.printf.net ([89.145.121.20]:44986 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab2HHEHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 00:07:22 -0400
From: Chris Ball <cjb@laptop.org>
To: NeilBrown <neilb@suse.de>
Cc: Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC/omap_hsmmc: handle failure of regulator_get better.
References: <20120730101245.7dbe72b0@notabene.brown>
Date: Wed, 08 Aug 2012 00:07:15 -0400
In-Reply-To: <20120730101245.7dbe72b0@notabene.brown> (NeilBrown's message of
	"Mon, 30 Jul 2012 10:12:45 +1000")
Message-ID: <874noeuivg.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 29 2012, NeilBrown wrote:
> 1/ if regulator_get fails, return an error.  This is important
>    if it failed with EPROBE_DEFER, as the probe needs to be
>    deferred.
>
> 2/ Don't set .set_power until the regulator has been found, or
>    the deferred probe will not bother calling omap_hsmmc_reg_get().
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 389a3ee..f052c29 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -299,12 +299,12 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
>  	struct regulator *reg;
>  	int ocr_value = 0;
>  
> -	mmc_slot(host).set_power = omap_hsmmc_set_power;
> -
>  	reg = regulator_get(host->dev, "vmmc");
>  	if (IS_ERR(reg)) {
>  		dev_dbg(host->dev, "vmmc regulator missing\n");
> +		return PTR_ERR(reg);
>  	} else {
> +		mmc_slot(host).set_power = omap_hsmmc_set_power;
>  		host->vcc = reg;
>  		ocr_value = mmc_regulator_get_ocrmask(reg);
>  		if (!mmc_slot(host).ocr_mask) {

Thanks, pushed to mmc-next for 3.7.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
