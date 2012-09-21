Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689Ab2IUJRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:17:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55332 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2IUJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:17:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH 10/13] spi: omap2-mcspi: dma_request_slave_channel() support for DT platforms
Date: Fri, 21 Sep 2012 08:16:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Matt Porter <mporter@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
References: <1348152226-13588-1-git-send-email-mporter@ti.com> <1348152226-13588-11-git-send-email-mporter@ti.com> <20120920220931.GJ28835@atomide.com>
In-Reply-To: <20120920220931.GJ28835@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209210816.01473.arnd@arndb.de>
X-Provags-ID: V02:K0:iAitw32smcVV1prmYGdZQwRMMJ0+aZjNfJmbmKGDDAZ
 33rd0Bw91yQeqWuLAJjpp9Z8Rkn9+80ZctgXVW+sb32CWoYb6/
 PNHynaou2axMuyMJqvKLqZvHzcPxiW4CaClg73BtANX5dVhZGx
 rkW1CjxKe1lpxVLcS3vtZm3JUOGoRZ1QXLwiKKvEs2hDCjXdCd
 ShTbmfWsWhSLKnDCZOKjkC914Br/Syj+hR2CaRIaoq6LWSlyWT
 PoeDAKRAR+T22+fY+lq6PK+8DVeNMROxJHooMuJ1U6PAkDY/My
 uNf2n4gcP/sx2bzDH1GuUJUgkFCa1wGbCXQDPoVyAPTgUxGQ77
 Njmbf1vCZV0AKepT3pio=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 September 2012, Tony Lindgren wrote:
> >  /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
> > @@ -798,14 +801,26 @@ static int omap2_mcspi_request_dma(struct spi_device *spi)
> >       dma_cap_zero(mask);
> >       dma_cap_set(DMA_SLAVE, mask);
> >       sig = mcspi_dma->dma_rx_sync_dev;
> > -     mcspi_dma->dma_rx = dma_request_channel(mask, omap_dma_filter_fn, &sig);
> > +     if (spi->dev.of_node)
> > +             mcspi_dma->dma_rx =
> > +                     dma_request_slave_channel(&master->dev,
> > +                                               mcspi_dma->dma_rx_ch_name);
> > +     else
> > +             mcspi_dma->dma_rx =
> > +                     dma_request_channel(mask, omap_dma_filter_fn, &sig);
> >       if (!mcspi_dma->dma_rx) {
> >               dev_err(&spi->dev, "no RX DMA engine channel for McSPI\n");
> >               return -EAGAIN;
> >       }
> >  
> 
> Hmm this does not look nice.. We should be able to somehow not to care about
> the configuration at the mcspi driver level.

I agree, but as far as I understand Vinod's plans, we would actually move
all drivers over to dma_request_slave_channel() when we have an interface
to register the lookup tables from platform code.

I think the above is ok for a transitional phase and we can remove the
fallback path when we have converted all platforms using this driver
to either use DT or move to the new style way of passing the channel
configuration.

	Arnd

