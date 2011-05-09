Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1EIQCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 12:02:32 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65296 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab1EIQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 12:02:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BzkOiuWM9YeVIhl6BZs7io9a5VqBjHi9Ss3ITCdMLPljSELQtX6ufVEaCZwLWUmflP
         hn9Lgq+v+ROQHvHyZ580QOGpPHV7J/9Cs0k2QwEoLTWVyZ6cTReZ3TY5+jN/rMP0F+0p
         SXZZfTwRdzJfkX7XyTphOIDXHnREcdJa9pjGs=
Subject: Re: [PATCH] regulator: Factor out references to rdev in
 regulator_force_disable()
From: Liam Girdwood <lrg@kernel.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1304934062-22847-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1304934062-22847-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 17:02:23 +0100
Message-ID: <1304956943.3192.19.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-09 at 11:41 +0200, Mark Brown wrote:
> Don't go looking up the rdev pointer every time, just use a local variable
> like everything else.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index c5b3c50..58452ac 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1508,13 +1508,14 @@ static int _regulator_force_disable(struct regulator_dev *rdev,
>   */
>  int regulator_force_disable(struct regulator *regulator)
>  {
> +	struct regulator_dev *rdev = regulator->rdev;
>  	struct regulator_dev *supply_rdev = NULL;
>  	int ret;
>  
> -	mutex_lock(&regulator->rdev->mutex);
> +	mutex_lock(&rdev->mutex);
>  	regulator->uA_load = 0;
> -	ret = _regulator_force_disable(regulator->rdev, &supply_rdev);
> -	mutex_unlock(&regulator->rdev->mutex);
> +	ret = _regulator_force_disable(rdev, &supply_rdev);
> +	mutex_unlock(&rdev->mutex);
>  
>  	if (supply_rdev)
>  		regulator_disable(get_device_regulator(rdev_get_dev(supply_rdev)));


Applied.

Thanks

Liam

