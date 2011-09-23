Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1IWX3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:29:40 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36337 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1IWX3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:29:39 -0400
Date: Fri, 23 Sep 2011 17:29:36 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jeff Harris <jeff_harris@kentrox.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: Fix WARN when removing spi-fsl-spi module
Message-ID: <20110923232936.GI24631@ponder.secretlab.ca>
References: <1316792976-28498-1-git-send-email-jeff_harris@kentrox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316792976-28498-1-git-send-email-jeff_harris@kentrox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 11:49:36AM -0400, Jeff Harris wrote:
> If CPM mode is not used, the fsl_dummy_rx variable is never allocated.  When
> the cleanup attempts to free it, the reference count is zero and a WARN is
> generated.  The same CPM mode check used in the initialize is applied to the
> free as well.
> 
> Tested on 2.6.33 with the previous spi_mpc8xxx driver.  The renamed
> spi-fsl-spi driver looks to have the same problem.
> 
> Signed-off-by: Jeff Harris <jeff_harris@kentrox.com>

Merged, thanks.

g.

> ---
>  drivers/spi/spi-fsl-spi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> index d240755..24cacff 100644
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -825,6 +825,9 @@ static void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
>  {
>  	struct device *dev = mspi->dev;
>  
> +	if (!(mspi->flags & SPI_CPM_MODE))
> +		return;
> +
>  	dma_unmap_single(dev, mspi->dma_dummy_rx, SPI_MRBLR, DMA_FROM_DEVICE);
>  	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
>  	cpm_muram_free(cpm_muram_offset(mspi->tx_bd));
> -- 
> 1.7.0.5
> 
