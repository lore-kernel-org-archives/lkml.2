Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1L0L3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 06:29:38 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24523
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab1L0L3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 06:29:34 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz1803M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Tue, 27 Dec 2011 19:38:47 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linaro-dev@lists.linaro.org>,
        <patches@linaro.org>, <eric.miao@linaro.org>,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3] Regulator: Add Anatop regulator driver
Message-ID: <20111227113845.GA24440@S2101-09.ap.freescale.net>
References: <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
 <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1324980994-18462-1-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:16:34PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop is an integrated regulator inside i.MX6 SoC.
> There are 3 digital regulators which controls PU, CORE (ARM), and SOC.
> And 3 analog regulators which controls 1P1, 2P5, 3P0 (USB).
> This patch adds the Anatop regulator driver.
> 
> Signed-off-by: Nancy Chen <Nancy.Chen@freescale.com>
> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Liam Girdwood <lrg@ti.com>
> ---
>  drivers/regulator/Kconfig                  |    6 +
>  drivers/regulator/Makefile                 |    1 +
>  drivers/regulator/anatop-regulator.c       |  214 ++++++++++++++++++++++++++++
>  include/linux/regulator/anatop-regulator.h |   63 ++++++++
>  4 files changed, 284 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/regulator/anatop-regulator.c
>  create mode 100644 include/linux/regulator/anatop-regulator.h
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 9713b1b..fc22b8d 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -327,5 +327,11 @@ config REGULATOR_AAT2870
>  	  If you have a AnalogicTech AAT2870 say Y to enable the
>  	  regulator driver.
>  
> +config REGULATOR_ANATOP
> +	tristate "ANATOP LDO regulators"
> +	depends on SOC_IMX6

There is no symbol 'SOC_IMX6'.  Instead, it's 'SOC_IMX6Q'.

[...]

> +int anatop_regulator_probe(struct platform_device *pdev)
> +{
> +	struct regulator_desc *rdesc;
> +	struct regulator_dev *rdev;
> +	struct anatop_regulator *sreg;
> +	struct regulator_init_data *initdata;
> +
> +	initdata = pdev->dev.platform_data;

It seems that the driver only gets probed in non-dt way.  But imx6q
only supports DT.  How does this driver work on imx6q?

PS. The regulator DT binding has been available on -next, so I do not
understand why you are still getting regulator_init_data from
platform_data rather than device tree.

-- 
Regards,
Shawn

