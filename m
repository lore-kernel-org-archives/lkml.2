Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1G0IPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 04:15:30 -0400
Received: from smtp-68.nebula.fi ([83.145.220.68]:46400 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1G0IP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 04:15:27 -0400
Date: Wed, 27 Jul 2011 11:15:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] adp1653: check error code of adp1653_init_controls
Message-ID: <20110727081522.GH32629@valkosipuli.localdomain>
References: <1b238cd98e03909bc4955113ffbe7e0c9f0db4f8.1311753459.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b238cd98e03909bc4955113ffbe7e0c9f0db4f8.1311753459.git.andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 10:58:02AM +0300, Andy Shevchenko wrote:
> Potentially the adp1653_init_controls could return an error. In our case the
> error was ignored, meanwhile it means incorrect initialization of V4L2
> controls.

Hi, Andy!

Many thanks for the another patch! I'll add this to my next pull req as
well.

Just FYI: As this is clearly a regular patch for the V4L2 subsystem, I think
cc'ing the linux-kernel list isn't necessary.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/adp1653.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> index 8ad89ff..3379e6d 100644
> --- a/drivers/media/video/adp1653.c
> +++ b/drivers/media/video/adp1653.c
> @@ -429,7 +429,11 @@ static int adp1653_probe(struct i2c_client *client,
>  	flash->subdev.internal_ops = &adp1653_internal_ops;
>  	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>  
> -	adp1653_init_controls(flash);
> +	ret = adp1653_init_controls(flash);
> +	if (ret) {
> +		kfree(flash);
> +		return ret;
> +	}
>  
>  	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
>  	if (ret < 0)
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
