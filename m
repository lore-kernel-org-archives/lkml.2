Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab2IDHZa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:25:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51547 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2IDHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:25:28 -0400
Date: Tue, 4 Sep 2012 09:25:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        kernel@pengutronix.de
Subject: Re: [PATCH] Revert "spi/doc: spi_master_put must be followed up by
 kfree"
Message-ID: <20120904072523.GB28643@pengutronix.de>
References: <1346703986-7849-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1346703986-7849-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 01:26:26PM -0700, Guenter Roeck wrote:
> Actually, spi_master_put() after spi_alloc_master() must _not_ be followed
> by kfree(). The memory is already freed with the call to spi_master_put()
> through spi_master_class, which registers a release function. Calling both
> spi_master_put() and kfree() results in often nasty (and delayed) crashes
> elsewhere in the kernel, often in the networking stack.
> 
> This reverts commit eb4af0f5349235df2e4a5057a72fc8962d00308a.
> 
> Cc: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
I didn't check the callback, but I introduced
eb4af0f5349235df2e4a5057a72fc8962d00308a because I saw the kfree in
drivers/spi/spi-imx.c. So I guess this needs fixing, too?!

Best regards
Uwe

> ---
>  drivers/spi/spi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 2d9b5bb..6470750 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1082,8 +1082,7 @@ static struct class spi_master_class = {
>   *
>   * The caller is responsible for assigning the bus number and initializing
>   * the master's methods before calling spi_register_master(); and (after errors
> - * adding the device) calling spi_master_put() and kfree() to prevent a memory
> - * leak.
> + * adding the device) calling spi_master_put() to prevent a memory leak.
>   */
>  struct spi_master *spi_alloc_master(struct device *dev, unsigned size)
>  {

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
