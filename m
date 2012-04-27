Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2D0HfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:35:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33750 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab2D0HfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:35:08 -0400
Date: Fri, 27 Apr 2012 09:35:04 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Dong Aisheng <b29396@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com,
        swarren@wwwdotorg.org, shawn.guo@freescale.com, kernel@pengutronix.de,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, cjb@laptop.org,
        b20223@freescale.com
Subject: Re: [PATCH v3 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl
 subsystem
Message-ID: <20120427073504.GS17184@pengutronix.de>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-4-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335451227-27709-4-git-send-email-b29396@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:32:28 up 166 days, 15:19, 56 users,  load average: 0.02, 0.54,
 0.90
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 10:40:27PM +0800, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> This driver is shared between many platforms. Currently only imx6q has
> pinctrl support, to avoid breaking other platforms that do not have pinctrl
> support to run this driver, enable pinctrl dummy state for them before
> they also convert to pinctrl subsystem.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> ---
> This patch depends on:
> pinctrl: add pinctrl_provide_dummies interface for platforms to use
> http://www.spinics.net/lists/arm-kernel/msg171538.html
> 
> ChangeLog v2->v3:
>  * patch name updated.
>    v1 name is ARM: imx6q: switch to use pinctrl driver
>  * using pinctrl dummy state to avoid breaking other platforms to use this
>    driver.
> 
> ChangeLog v1->v2:
>  * using updated binding
> ---
>  arch/arm/boot/dts/imx6q-arm2.dts               |    4 +++
>  arch/arm/boot/dts/imx6q.dtsi                   |   32 ++++++++++++++++++++++++
>  arch/arm/mach-imx/Kconfig                      |    2 +
>  arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c |    2 +
>  arch/arm/mach-imx/mach-cpuimx51.c              |    2 +
>  arch/arm/mach-imx/mach-cpuimx51sd.c            |    2 +
>  arch/arm/mach-imx/mach-eukrea_cpuimx25.c       |    2 +
>  arch/arm/mach-imx/mach-mx25_3ds.c              |    2 +
>  arch/arm/mach-imx/mach-mx35_3ds.c              |    2 +
>  arch/arm/mach-imx/mach-mx51_3ds.c              |    2 +
>  arch/arm/mach-imx/mach-mx51_babbage.c          |    2 +
>  arch/arm/mach-imx/mach-mx51_efikamx.c          |    2 +
>  arch/arm/mach-imx/mach-mx51_efikasb.c          |    2 +
>  arch/arm/mach-imx/mach-mx53_ard.c              |    2 +
>  arch/arm/mach-imx/mach-mx53_evk.c              |    2 +
>  arch/arm/mach-imx/mach-mx53_loco.c             |    2 +
>  arch/arm/mach-imx/mach-mx53_smd.c              |    2 +
>  arch/arm/mach-imx/mach-pcm043.c                |    2 +
>  arch/arm/mach-imx/mach-vpr200.c                |    2 +

Here you are patching only the boards which happen to use the esdhc
controller, so we need to patch other boards when another driver gains
pinctrl. Let's add the provide_dummies call to the SoCs instead which
do not have pinctrl yet.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
