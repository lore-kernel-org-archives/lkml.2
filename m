Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab1ESTAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:00:38 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:35545 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933670Ab1ESTAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:00:36 -0400
Date: Thu, 19 May 2011 13:00:34 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] spi: Use void pointers for data in simple SPI I/O
 operations
Message-ID: <20110519190034.GF5109@ponder.secretlab.ca>
References: <1305065370-28616-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305065370-28616-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 12:09:30AM +0200, Mark Brown wrote:
> Currently the simple SPI I/O operations all take pointers to u8 * buffers
> to operate on. This creates needless type compatibility issues and the
> underlying spi_transfer structure uses void pointers anyway so convert the
> API over to take void pointers too.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Merged, thanks.

g.

> ---
>  drivers/spi/spi.c       |    4 ++--
>  include/linux/spi/spi.h |    8 ++++----
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 82b9a42..2e13a14 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1047,8 +1047,8 @@ static u8	*buf;
>   * spi_{async,sync}() calls with dma-safe buffers.
>   */
>  int spi_write_then_read(struct spi_device *spi,
> -		const u8 *txbuf, unsigned n_tx,
> -		u8 *rxbuf, unsigned n_rx)
> +		const void *txbuf, unsigned n_tx,
> +		void *rxbuf, unsigned n_rx)
>  {
>  	static DEFINE_MUTEX(lock);
>  
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index b4d7710..bb4f5fb 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -581,7 +581,7 @@ extern int spi_bus_unlock(struct spi_master *master);
>   * Callable only from contexts that can sleep.
>   */
>  static inline int
> -spi_write(struct spi_device *spi, const u8 *buf, size_t len)
> +spi_write(struct spi_device *spi, const void *buf, size_t len)
>  {
>  	struct spi_transfer	t = {
>  			.tx_buf		= buf,
> @@ -605,7 +605,7 @@ spi_write(struct spi_device *spi, const u8 *buf, size_t len)
>   * Callable only from contexts that can sleep.
>   */
>  static inline int
> -spi_read(struct spi_device *spi, u8 *buf, size_t len)
> +spi_read(struct spi_device *spi, void *buf, size_t len)
>  {
>  	struct spi_transfer	t = {
>  			.rx_buf		= buf,
> @@ -620,8 +620,8 @@ spi_read(struct spi_device *spi, u8 *buf, size_t len)
>  
>  /* this copies txbuf and rxbuf data; for small transfers only! */
>  extern int spi_write_then_read(struct spi_device *spi,
> -		const u8 *txbuf, unsigned n_tx,
> -		u8 *rxbuf, unsigned n_rx);
> +		const void *txbuf, unsigned n_tx,
> +		void *rxbuf, unsigned n_rx);
>  
>  /**
>   * spi_w8r8 - SPI synchronous 8 bit write followed by 8 bit read
> -- 
> 1.7.5.1
> 
