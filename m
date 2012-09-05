Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2IEEDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:03:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51947 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2IEEDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:03:16 -0400
Date: Wed, 5 Sep 2012 12:03:19 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3 2/4] misc: Generic on-chip SRAM allocation driver
Message-ID: <20120905040317.GX2362@S2101-09.ap.freescale.net>
References: <1346688128-22395-1-git-send-email-p.zabel@pengutronix.de>
 <1346688128-22395-3-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346688128-22395-3-git-send-email-p.zabel@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 06:02:06PM +0200, Philipp Zabel wrote:
> +static struct platform_driver sram_driver = {
> +	.driver = {
> +		.name = "sram",
> +		.of_match_table = of_match_ptr(sram_dt_ids),
> +	},
> +	.probe = sram_probe,
> +	.remove = __devexit_p(sram_remove),
> +};
> +
> +module_platform_driver(sram_driver);

I think we'd better make it a postcore_initcall time driver, so that
it can be ensured that when the client drivers call gen_pool_* API
the pool has been created by sram_driver. 

-- 
Regards,
Shawn
