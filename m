Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1BQIrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 03:47:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40861 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab1BQIrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 03:47:08 -0500
Date: Thu, 17 Feb 2011 09:47:05 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Driver core: convert platform_{get,set}_drvdata to
 static inline functions
Message-ID: <20110217084705.GA7435@pengutronix.de>
References: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1297895007-2104-1-git-send-email-mkl@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Feb 16, 2011 at 11:23:27PM +0100, Marc Kleine-Budde wrote:
> This patch converts the macros for platform_{get,set}_drvdata to
> static inline functions to add typechecking.
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
> Changes since v1:
> - remove ugly macro magic, use static inline functions instead
> 
>  include/linux/platform_device.h |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
> index 2e700ec..d96db98 100644
> --- a/include/linux/platform_device.h
> +++ b/include/linux/platform_device.h
> @@ -130,8 +130,15 @@ extern void platform_driver_unregister(struct platform_driver *);
>  extern int platform_driver_probe(struct platform_driver *driver,
>  		int (*probe)(struct platform_device *));
>  
> -#define platform_get_drvdata(_dev)	dev_get_drvdata(&(_dev)->dev)
> -#define platform_set_drvdata(_dev,data)	dev_set_drvdata(&(_dev)->dev, (data))
> +static inline void *platform_get_drvdata(const struct platform_device *pdev)
> +{
> +	return dev_get_drvdata(&pdev->dev);
> +}
> +
> +static inline void platform_set_drvdata(struct platform_device *pdev, void *data)
> +{
> +	dev_set_drvdata(&pdev->dev, data);
> +}
Another improvement would be to make dev_set_drvdata and
platform_set_drvdata return an int (as dev_set_drvdata can fail) (and
then maybe mark it __must_check).

Other than that,

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
