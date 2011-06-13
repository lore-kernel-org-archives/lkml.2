Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab1FMPJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 11:09:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64014 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1FMPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 11:08:58 -0400
Date: Mon, 13 Jun 2011 09:08:56 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org
Subject: Re: [PATCH] spi-pl022: Add missing return value update
Message-ID: <20110613150856.GD18161@ponder.secretlab.ca>
References: <1307962426-19230-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307962426-19230-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 04:23:46PM +0530, Virupax Sadashivpetimath wrote:
> Return error on out of range cpsdvsr value.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

It looks like this is a bug fix for v3.0, and probably for -stable too, correct?

g.

> ---
>  drivers/spi/spi-pl022.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index 2541705..b3bd8d8 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -1859,6 +1859,7 @@ static int pl022_setup(struct spi_device *spi)
>  	}
>  	if ((clk_freq.cpsdvsr < CPSDVR_MIN)
>  	    || (clk_freq.cpsdvsr > CPSDVR_MAX)) {
> +		status = -EINVAL;
>  		dev_err(&spi->dev,
>  			"cpsdvsr is configured incorrectly\n");
>  		goto err_config_params;
> -- 
> 1.7.4.3
> 
