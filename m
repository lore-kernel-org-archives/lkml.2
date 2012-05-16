Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628Ab2EPRzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:55:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36682 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267Ab2EPRzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:55:22 -0400
Date: Wed, 16 May 2012 19:55:15 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Robert Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Subject: Re: [PATCH v4 5/7] ARM: imx: Add common imx cpuidle init
 functionality.
Message-ID: <20120516175515.GX30400@pengutronix.de>
References: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
 <1337135616-8988-6-git-send-email-rob.lee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337135616-8988-6-git-send-email-rob.lee@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:50:44 up 186 days,  1:37, 31 users,  load average: 0.00, 0.04,
 0.46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 09:33:34PM -0500, Robert Lee wrote:
> Add common cpuidle init functionality that can be used by various
> imx platforms.
> 
> Signed-off-by: Robert Lee <rob.lee@linaro.org>
> ---
> +
> +#ifdef CONFIG_CPU_IDLE
> +extern int imx_cpuidle_init(struct cpuidle_driver *drv);
> +#else
> +static inline int imx_cpuidle_init(struct cpuidle_driver *drv)
> +{
> +	return -ENODEV;
> +}
> +#endif

You should return succesfully here. Think about it, if imx_cpuidle_init
fails you basically do nothing except maybe printing an error message
which will be irritating when it appears on a kernel with cpuidle
disabled.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
