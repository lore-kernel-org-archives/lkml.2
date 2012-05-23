Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2EWQW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:22:27 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:32670
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351Ab2EWQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:22:25 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 24 May 2012 00:42:04 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Fabio Estevam <festevam@gmail.com>, <marc@cpdesign.com.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120523164203.GA7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120523084945.GA4085@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:49:46AM +0100, Mark Brown wrote:
> On Tue, May 22, 2012 at 11:05:35PM -0300, Fabio Estevam wrote:
> 
> > Should the spi->mode and spi->bits_per_word be passed differently?
> 
> > Maybe via "struct regmap_config" ?
> 
> You shouldn't be setting bits_per_word at all, that'll corrupt the data
> that regmap has formatted.  Does removing that alone resolve the issue?

Removing that alone does not resolve the issue, but with additional
.write_flag_mask setting it does for me.

Regards,
Shawn

diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..5d1969f 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
        .reg_bits = 7,
        .pad_bits = 1,
        .val_bits = 24,
+       .write_flag_mask = 0x80,

        .max_register = MC13XXX_NUMREGS,

@@ -73,7 +74,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)

        dev_set_drvdata(&spi->dev, mc13xxx);
        spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-       spi->bits_per_word = 32;

        mc13xxx->dev = &spi->dev;
        mutex_init(&mc13xxx->lock);


