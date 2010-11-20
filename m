Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0KTVs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:48:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40465 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab0KTVs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:48:28 -0500
Date: Sat, 20 Nov 2010 22:48:20 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Patrice Vilchez <patrice.vilchez@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] atmel_spi: fix warning In function
	'atmel_spi_dma_map_xfer'
Message-ID: <20101120214820.GG8942@pengutronix.de>
References: <20101120095906.GD4216@game.jcrosoft.org> <1290247733-17834-6-git-send-email-plagnioj@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290247733-17834-6-git-send-email-plagnioj@jcrosoft.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[adding spi-devel-general and lkml to Cc:]

On Sat, Nov 20, 2010 at 11:08:53AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> passing argument 2 of 'dma_map_single' discards qualifiers from pointer target type
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> ---
>  drivers/spi/atmel_spi.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> index 154529a..2cf6abd 100644
> --- a/drivers/spi/atmel_spi.c
> +++ b/drivers/spi/atmel_spi.c
> @@ -352,8 +352,10 @@ atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
>  
>  	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
>  	if (xfer->tx_buf) {
> +		void *nonconst_tx = (void *)xfer->tx_buf; /* shut up gcc */
> +
>  		xfer->tx_dma = dma_map_single(dev,
> -				(void *) xfer->tx_buf, xfer->len,
> +				nonconst_tx, xfer->len,
>  				DMA_TO_DEVICE);
Hmm, I wonder if this is the right approach to do this.  I'd prefer to
have something like:

	dma_map_single_to_device(struct device *, const void *, ...)

don't know if that's sensible though.

And I wonder about gcc that your patch makes a difference.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
