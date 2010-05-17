Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0EQOgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 10:36:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62258 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab0EQOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 10:36:03 -0400
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linus Walleij <linus.walleij@stericsson.com>
In-Reply-To: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 15:35:29 +0100
Message-ID: <1274106929.3185.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 19:39 +0530, Sundar Iyer wrote:
> From: Sundar R Iyer <sundar.iyer@stericsson.com>
> 
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
> ---
>  drivers/regulator/core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 98e5d14..5054add 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1599,6 +1599,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
>  {
>  	struct regulator_dev *rdev = regulator->rdev;
>  	int ret;
> +	int regulator_curr_mode;

Shouldn't this variable be in regulator_set_mode() ?

>  
>  	mutex_lock(&rdev->mutex);
>  
> @@ -1754,6 +1755,13 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
>  		goto out;
>  	}
>  
> +	/* return if the same mode is requested */
> +	regulator_curr_mode = rdev->desc->ops->get_mode(rdev);
> +	if (regulator_curr_mode == mode) {
> +		ret = 0;
> +		goto out;
> +	}
> +
>  	/* constraints check */
>  	ret = regulator_check_mode(rdev, mode);
>  	if (ret < 0)

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

