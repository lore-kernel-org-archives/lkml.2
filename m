Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab2DPUxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:53:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54288 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2DPUxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:53:04 -0400
Date: Mon, 16 Apr 2012 22:52:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: arnd.bergmann@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Rajendra Nayak <rnayak@ti.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>, Olof Johansson <olof@lixom.net>,
        linaro-dev@lists.linaro.org, Richard Zhao <richard.zhao@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
Message-ID: <20120416205259.GI20478@pengutronix.de>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-14-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334192572-12499-14-git-send-email-mturquette@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:30:20 up 156 days,  4:17, 20 users,  load average: 0.01, 0.19,
 0.45
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:02:51PM -0700, Mike Turquette wrote:
> This patch is the basic clk version of 'clk: core: copy parent_names &
> return error codes'.
> 
> The registration functions are changed to allow the core code to copy
> the array of strings and allow platforms to declare those arrays as
> __initdata.
> 
> This patch also converts all of the basic clk registration functions to
> return error codes which better aligns them with the existing clk.h api.
> 
> 
> + */
>  struct clk *clk_register_divider(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
>  		void __iomem *reg, u8 shift, u8 width,
>  		u8 clk_divider_flags, spinlock_t *lock)
>  {
>  	struct clk_divider *div;
> -	struct clk *clk;
> +	struct clk *clk = ERR_PTR(-ENOMEM);
> +	const char *parent_names[1];
>  
> +	/* allocate the divider */
>  	div = kzalloc(sizeof(struct clk_divider), GFP_KERNEL);
> -
>  	if (!div) {
>  		pr_err("%s: could not allocate divider clk\n", __func__);
>  		return NULL;

You missed a conversion to ERR_PTR here.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
