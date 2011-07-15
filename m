Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1GOT4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 15:56:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52955 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab1GOT43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 15:56:29 -0400
Date: Fri, 15 Jul 2011 13:56:26 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/3] mcp23s08: get rid of setup/teardown callbacks
Message-ID: <20110715195626.GH2833@ponder.secretlab.ca>
References: <1310718332-10438-1-git-send-email-jacmet@sunsite.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310718332-10438-1-git-send-email-jacmet@sunsite.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 10:25:30AM +0200, Peter Korsgaard wrote:
> There's no in-tree users, and bus notifiers are more generic anyway.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>

Applied all three, thanks.

g.

> ---
>  drivers/gpio/gpio-mcp23s08.c |   19 -------------------
>  include/linux/spi/mcp23s08.h |    9 ---------
>  2 files changed, 0 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> index da3e04f..ef61234 100644
> --- a/drivers/gpio/gpio-mcp23s08.c
> +++ b/drivers/gpio/gpio-mcp23s08.c
> @@ -432,14 +432,6 @@ static int mcp23s08_probe(struct spi_device *spi)
>  	 * handled here...
>  	 */
>  
> -	if (pdata->setup) {
> -		status = pdata->setup(spi,
> -				pdata->base, data->ngpio,
> -				pdata->context);
> -		if (status < 0)
> -			dev_dbg(&spi->dev, "setup --> %d\n", status);
> -	}
> -
>  	return 0;
>  
>  fail:
> @@ -459,20 +451,9 @@ fail:
>  static int mcp23s08_remove(struct spi_device *spi)
>  {
>  	struct mcp23s08_driver_data	*data = spi_get_drvdata(spi);
> -	struct mcp23s08_platform_data	*pdata = spi->dev.platform_data;
>  	unsigned			addr;
>  	int				status = 0;
>  
> -	if (pdata->teardown) {
> -		status = pdata->teardown(spi,
> -				pdata->base, data->ngpio,
> -				pdata->context);
> -		if (status < 0) {
> -			dev_err(&spi->dev, "%s --> %d\n", "teardown", status);
> -			return status;
> -		}
> -	}
> -
>  	for (addr = 0; addr < ARRAY_SIZE(data->mcp); addr++) {
>  		int tmp;
>  
> diff --git a/include/linux/spi/mcp23s08.h b/include/linux/spi/mcp23s08.h
> index c42cff8..2d676d5 100644
> --- a/include/linux/spi/mcp23s08.h
> +++ b/include/linux/spi/mcp23s08.h
> @@ -22,13 +22,4 @@ struct mcp23s08_platform_data {
>  	 * base to base+15 (or base+31 for s17 variant).
>  	 */
>  	unsigned	base;
> -
> -	void		*context;	/* param to setup/teardown */
> -
> -	int		(*setup)(struct spi_device *spi,
> -					int gpio, unsigned ngpio,
> -					void *context);
> -	int		(*teardown)(struct spi_device *spi,
> -					int gpio, unsigned ngpio,
> -					void *context);
>  };
> -- 
> 1.7.5.4
> 
