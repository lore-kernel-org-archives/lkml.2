Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab1GZL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 07:28:35 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:42989 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1GZL23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 07:28:29 -0400
Date: Tue, 26 Jul 2011 14:28:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] adp1653: check platform_data before usage
Message-ID: <20110726112825.GB32507@valkosipuli.localdomain>
References: <55316b63b7084f869d550fd600f29d2e0dfa862c.1311603384.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55316b63b7084f869d550fd600f29d2e0dfa862c.1311603384.git.andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andy!

On Mon, Jul 25, 2011 at 05:16:41PM +0300, Andy Shevchenko wrote:
> The driver requires platform_data to be present. That's why we need to check
> and fail in case of the absence of necessary data.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/adp1653.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)

Thanks for the patch. I'll add this to my next pull req.

> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index be7befd..8ad89ff 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -413,6 +413,10 @@ static int adp1653_probe(struct i2c_client *client,
>  	struct adp1653_flash *flash;
>  	int ret;
>  
> +	/* we couldn't work without platform data */
> +	if (client->dev.platform_data == NULL)
> +		return -ENODEV;
> +
>  	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
>  	if (flash == NULL)
>  		return -ENOMEM;
> -- 
> 1.7.5.4
> 

-- 
Sakari Ailus
sakari.ailus@iki.fi
