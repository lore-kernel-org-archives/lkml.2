Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225Ab2C1Vnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:43:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57216 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130Ab2C1Vny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:43:54 -0400
From: Marc Reilly <marc@cpdesign.com.au>
Reply-To: marc@cpdesign.com.au
Organization: Creative Product Design
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Date: Thu, 29 Mar 2012 07:47:50 +1100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.11-desktop; KDE/4.6.0; x86_64; ; )
Cc: Alex Gershgorin <alexg@meprolight.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        fabio.estevam@freescale.com, sameo@linux.intel.com,
        s.hauer@pengutronix.de, linux-kernel@vger.kernel.org
References: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
In-Reply-To: <1332943273-22447-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203290747.50881.marc@cpdesign.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

As Mark Brown already said, these changes should be squashed into a new 
version of the patches.

On Thursday, March 29, 2012 01:01:13 AM Alex Gershgorin wrote:
> This patch fixes the compilation errors after the patches
> from series mc13xxx-add-I2C-support-V4 were applied.
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  drivers/mfd/Kconfig        |    2 ++
>  drivers/mfd/mc13xxx-core.c |    2 +-
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index c3fbc5e..2119732 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -577,6 +577,8 @@ config MFD_MC13XXX
>  	depends on SPI_MASTER || I2C
>  	select MFD_CORE
>  	select MFD_MC13783
> +	select REGMAP_I2C if I2C
This can go under the "config MFD_MC13XXX_I2C" entry in patch 4/4 (the "if 
I2C" won't be needed)

> +	select REGMAP_SPI if SPI_MASTER
This can go under the "config MFD_MC13XXX_SPI" entry in patch 3/4


>  	help
>  	  Enable support for the Freescale MC13783 and MC13892 PMICs.
>  	  This driver provides common support for accessing the device,
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 31dbf91..5a60273 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -616,7 +616,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx
> *mc13xxx, const char *format) #ifdef CONFIG_OF
>  static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
>  {
> -	struct device_node *np = mc13xxx->dev.of_node;
> +	struct device_node *np = mc13xxx->dev->of_node;

Good catch! This can be fixed up in 4/4

@Alex, you seen keen to do this, so I'll leave it to you :)
Otherwise, I'm happy to do it, just let me know.

Cheers,
Marc

