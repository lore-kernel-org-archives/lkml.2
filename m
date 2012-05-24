Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2EXFoY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 01:44:24 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:32189
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346Ab2EXFoX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 01:44:23 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839hd25hf0ah)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 24 May 2012 14:04:03 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, <marc@cpdesign.com.au>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524060402.GC7843@S2100-06.ap.freescale.net>
References: <CAOMZO5A-05jTYpEEPfnJvWpby1YJ1M7=KPn=zahbQrQOgbjR4g@mail.gmail.com>
 <201205221053.21792.marc@cpdesign.com.au>
 <CAOMZO5BCcFOktp9mqDCpnrVhbK6pwO1R3ZdiKPfawb=KLjzzWw@mail.gmail.com>
 <CAOMZO5DKsrXJoSSacwYFoHUw6pPWLWQnC3gS=6=3k6nvf6tggw@mail.gmail.com>
 <20120523084945.GA4085@opensource.wolfsonmicro.com>
 <20120523164203.GA7843@S2100-06.ap.freescale.net>
 <CAOMZO5AOsdHqZ2Rth_m_BLEvHyLrJGEeXzmZZX=HyfeQZ7WTYw@mail.gmail.com>
 <20120524004851.GB7843@S2100-06.ap.freescale.net>
 <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAOMZO5A-LbgPFTbizK-NghboTs9rGWN2LnmQHEQEdo5Bhxtohg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 01:07:43AM -0300, Fabio Estevam wrote:
> Shawn,
> 
> On Wed, May 23, 2012 at 9:48 PM, Shawn Guo <shawn.guo@freescale.com> wrote:
> 
> > I'm booting my imx51 babbage with MC13892 with no problem now.  And
> > reading the registers give me the same values as I do with u-boot.
> 
> Ok, just to confirm: is the patch below that you are using?
> 
Yes.

Regards,
Shawn

> diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
> index 3fcdab3..5d1969f 100644
> --- a/drivers/mfd/mc13xxx-spi.c
> +++ b/drivers/mfd/mc13xxx-spi.c
> @@ -49,6 +49,7 @@ static struct regmap_config mc13xxx_regmap_spi_config = {
>  	.reg_bits = 7,
>  	.pad_bits = 1,
>  	.val_bits = 24,
> +	.write_flag_mask = 0x80,
> 
>  	.max_register = MC13XXX_NUMREGS,
> 
> @@ -73,7 +74,6 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
> 
>  	dev_set_drvdata(&spi->dev, mc13xxx);
>  	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
> -	spi->bits_per_word = 32;
> 
>  	mc13xxx->dev = &spi->dev;
>  	mutex_init(&mc13xxx->lock);
> 
> 
> I am trying to understand why mx31pdk still fails.
> 

