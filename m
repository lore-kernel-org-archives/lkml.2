Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab0JCDCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 23:02:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43064 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0JCDCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 23:02:44 -0400
Date: Sat, 2 Oct 2010 21:02:41 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi-gpio: SPI_MASTER_NO_RX bit tested twice, missing
 SPI_MASTER_NO_TX?
Message-ID: <20101003030241.GA28565@angua.secretlab.ca>
References: <4CA71F94.8050703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA71F94.8050703@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 02:03:32PM +0200, Roel Kluin wrote:
> The SPI_MASTER_NO_TX bit (can't do buffer write) wasn't tested.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/spi/spi_gpio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Is this what was intended?
> 

Obviously correct.  Merged

g.

> diff --git a/drivers/spi/spi_gpio.c b/drivers/spi/spi_gpio.c
> index e24a634..63e51b0 100644
> --- a/drivers/spi/spi_gpio.c
> +++ b/drivers/spi/spi_gpio.c
> @@ -350,7 +350,7 @@ static int __init spi_gpio_probe(struct platform_device *pdev)
>  	spi_gpio->bitbang.master = spi_master_get(master);
>  	spi_gpio->bitbang.chipselect = spi_gpio_chipselect;
>  
> -	if ((master_flags & (SPI_MASTER_NO_RX | SPI_MASTER_NO_RX)) == 0) {
> +	if ((master_flags & (SPI_MASTER_NO_TX | SPI_MASTER_NO_RX)) == 0) {
>  		spi_gpio->bitbang.txrx_word[SPI_MODE_0] = spi_gpio_txrx_word_mode0;
>  		spi_gpio->bitbang.txrx_word[SPI_MODE_1] = spi_gpio_txrx_word_mode1;
>  		spi_gpio->bitbang.txrx_word[SPI_MODE_2] = spi_gpio_txrx_word_mode2;
