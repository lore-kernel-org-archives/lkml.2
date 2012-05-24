Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2EXHNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 03:13:38 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17209
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116Ab2EXHNf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 03:13:35 -0400
X-SpamScore: -9
X-BigFish: VS-9(zzc89bh1432N98dKzz1202hzzz2dh2a8h668h839hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 24 May 2012 15:33:16 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Fabio Estevam <festevam@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <marc@cpdesign.com.au>, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524073315.GE7843@S2100-06.ap.freescale.net>
References: <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <20120523164203.GA7843@S2100-06.ap.freescale.net>
 <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
 <20120524004851.GB7843@S2100-06.ap.freescale.net>
 <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
 <20120524063859.GD7843@S2100-06.ap.freescale.net>
 <20120524064635.GP3710@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20120524064635.GP3710@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 08:46:35AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Thu, May 24, 2012 at 02:39:00PM +0800, Shawn Guo wrote:
> > On Thu, May 24, 2012 at 01:07:43AM -0300, Fabio Estevam wrote:
> > > I am trying to understand why mx31pdk still fails.
> > > 
> > So different from imx51-babbage which uses MC13892, mx31pdk uses
> > MC13783?  But both chips should have the same regmap, right?
> They are similar. One difference is the protocol used. MC13783 only
> speaks spi, MC13892 can do both, spi and i2c. Does someone has a working
> MC13892 that uses spi?
> 
I do.  With the following patch applied on top of linux-next, it works
on my imx51-babbage board.

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


