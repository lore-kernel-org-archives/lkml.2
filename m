Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab1I2UQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:16:21 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46438 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866Ab1I2UQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:16:19 -0400
Date: Thu, 29 Sep 2011 11:35:15 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Grant Likely <grant@secretlab.ca>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        "G, Manjunath Kondaiah" <manjugk@ti.com>
Subject: Re: [PATCH] regulator: Support driver probe deferral
Message-ID: <20110929163515.GA6800@ponder.secretlab.ca>
References: <1317294661-22080-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317294661-22080-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 12:11:01PM +0100, Mark Brown wrote:
> If we fail to locate a requested regulator return -EAGAIN. If drivers
> pass this error code through to their caller (which they really should)
> then this will ensure that the probe is retried later when further devices
> become available.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Manjunath, can you add this to a series with the deferred probe patch?
You'll need to change the return code as discussed in the other
thread.

g.

> ---
> 
> This depends on Grant's change to implement deferred probing, the error
> code for which is going to change in the next revision.  Liam, if you're
> also OK with this change I propose that we both ack it and let it get
> carried along with the deferred probing change.
> 
>  drivers/regulator/core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index d5656b7..b39ec9f 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1154,7 +1154,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  {
>  	struct regulator_dev *rdev;
>  	struct regulator_map *map;
> -	struct regulator *regulator = ERR_PTR(-ENODEV);
> +	struct regulator *regulator = ERR_PTR(-EAGAIN);
>  	const char *devname = NULL;
>  	int ret;
>  
> @@ -2727,7 +2727,7 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
>  		if (!found) {
>  			dev_err(dev, "Failed to find supply %s\n",
>  				init_data->supply_regulator);
> -			ret = -ENODEV;
> +			ret = -EAGAIN;
>  			goto scrub;
>  		}
>  
> -- 
> 1.7.6.3
> 
