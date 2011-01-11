Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1AKPUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:20:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52751 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1AKPU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:20:26 -0500
Date: Tue, 11 Jan 2011 08:20:21 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH 15/16] spi: dw_spi: don't treat NULL clk as an error
Message-ID: <20110111152021.GA2707@angua.secretlab.ca>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com>
 <1294749833-32019-16-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-16-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:52PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: spi-devel-general@lists.sourceforge.net
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Applied, thanks.

g.

> ---
>  drivers/spi/dw_spi_mmio.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/dw_spi_mmio.c b/drivers/spi/dw_spi_mmio.c
> index db35bd9..2fa012c 100644
> --- a/drivers/spi/dw_spi_mmio.c
> +++ b/drivers/spi/dw_spi_mmio.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/err.h>
>  #include <linux/interrupt.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> @@ -68,8 +69,8 @@ static int __devinit dw_spi_mmio_probe(struct platform_device *pdev)
>  	}
>  
>  	dwsmmio->clk = clk_get(&pdev->dev, NULL);
> -	if (!dwsmmio->clk) {
> -		ret = -ENODEV;
> +	if (IS_ERR(dwsmmio->clk)) {
> +		ret = PTR_ERR(dwsmmio->clk);
>  		goto err_irq;
>  	}
>  	clk_enable(dwsmmio->clk);
> -- 
> 1.7.3.4
> 
> 
> ------------------------------------------------------------------------------
> Gaining the trust of online customers is vital for the success of any company
> that requires sensitive data to be transmitted over the Web.   Learn how to 
> best implement a security strategy that keeps consumers' information secure 
> and instills the confidence they need to proceed with transactions.
> http://p.sf.net/sfu/oracle-sfdevnl 
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
