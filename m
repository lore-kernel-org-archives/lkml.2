Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab2FCVvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 17:51:19 -0400
Received: from mail.serverraum.org ([78.47.150.89]:47918 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2FCVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 17:51:18 -0400
From: Michael Walle <michael@walle.cc>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] spi-orion: remove uneeded spi_info
Date: Sun, 3 Jun 2012 23:51:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-686-bigmem; KDE/4.4.5; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        "open list:SPI SUBSYSTEM" <spi-devel-general@lists.sourceforge.net>,
        open list <linux-kernel@vger.kernel.org>
References: <1338754215-16022-1-git-send-email-michael@walle.cc> <20120603210424.GM14756@titan.lakedaemon.net>
In-Reply-To: <20120603210424.GM14756@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206032351.22925.michael@walle.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Am Sonntag 03 Juni 2012, 23:04:24 schrieb Jason Cooper:
> On Sun, Jun 03, 2012 at 10:10:14PM +0200, Michael Walle wrote:
> > This was formerly used to store the tclk value. Remove it.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> > 
> >  drivers/spi/spi-orion.c |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/spi/spi-orion.c b/drivers/spi/spi-orion.c
> > index dfd04e9..2760450 100644
> > --- a/drivers/spi/spi-orion.c
> > +++ b/drivers/spi/spi-orion.c
> > @@ -45,7 +45,6 @@ struct orion_spi {
> > 
> >  	void __iomem		*base;
> >  	unsigned int		max_speed;
> >  	unsigned int		min_speed;
> > 
> > -	struct orion_spi_info	*spi_info;
> > 
> >  	struct clk              *clk;
> >  
> >  };
> > 
> > @@ -450,12 +449,9 @@ static int __init orion_spi_probe(struct
> > platform_device *pdev)
> > 
> >  	struct spi_master *master;
> >  	struct orion_spi *spi;
> >  	struct resource *r;
> > 
> > -	struct orion_spi_info *spi_info;
> > 
> >  	unsigned long tclk_hz;
> >  	int status = 0;
> > 
> > -	spi_info = pdev->dev.platform_data;
> > -
> > 
> >  	master = spi_alloc_master(&pdev->dev, sizeof *spi);
> >  	if (master == NULL) {
> >  	
> >  		dev_dbg(&pdev->dev, "master allocation failed\n");
> > 
> > @@ -476,7 +472,6 @@ static int __init orion_spi_probe(struct
> > platform_device *pdev)
> > 
> >  	spi = spi_master_get_devdata(master);
> >  	spi->master = master;
> > 
> > -	spi->spi_info = spi_info;
> > 
> >  	spi->clk = clk_get(&pdev->dev, NULL);
> 
> It's not relevant to this patch, but later in the patch series, you
> initialize this device via devicetree.  Did you add the clock node?  Is
> there a dependency for this series that I missed?

i added the original device name by using the auxdata in 
of_platform_populate(). See "[PATCH 2/3] ARM: kirkwood: use devicetree for 
orion-spi"

-- 
Michael
