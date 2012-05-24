Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab2EXEHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:07:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44498 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2EXEHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:07:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120524004851.GB7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
	<201205221053.21792.marc@cpdesign.com.au>
	<CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
	<CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
	<20120523084945.GA4085@opensource.wolfsonmicro.com>
	<20120523164203.GA7843@S2100-06.ap.freescale.net>
	<CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
	<20120524004851.GB7843@S2100-06.ap.freescale.net>
Date: Thu, 24 May 2012 01:07:43 -0300
Message-ID: <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, marc@cpdesign.com.au,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,

On Wed, May 23, 2012 at 9:48 PM, Shawn Guo <shawn.guo@freescale.com> wrote:

> I'm booting my imx51 babbage with MC13892 with no problem now.  And
> reading the registers give me the same values as I do with u-boot.

Ok, just to confirm: is the patch below that you are using?

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..5d1969f 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
 	.reg_bits = 7,
 	.pad_bits = 1,
 	.val_bits = 24,
+	.write_flag_mask = 0x80,

 	.max_register = MC13XXX_NUMREGS,

@@ -73,7 +74,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)

 	dev_set_drvdata(&spi->dev, mc13xxx);
 	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;

 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);


I am trying to understand why mx31pdk still fails.
