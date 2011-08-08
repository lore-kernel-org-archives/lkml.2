Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1HHQk2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:40:28 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44604 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab1HHQkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:40:25 -0400
Subject: Re: [PATCH] regulator: max8952: removed unused mutex.
From: Liam Girdwood <lrg@kernel.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, Liam Girdwood <lrg@ti.com>
In-Reply-To: <1312333083-22615-1-git-send-email-myungjoo.ham@samsung.com>
References: <4E37FE95.7090808@ti.com>
	 <1312333083-22615-1-git-send-email-myungjoo.ham@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:40:20 +0100
Message-ID: <1312821620.3316.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 09:58 +0900, MyungJoo Ham wrote:
> This patch removes a mutex that is never used in the driver.
> 
> Reported-by: Axel Lin
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/regulator/max8952.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
> index daff7fd..2fa8a81 100644
> --- a/drivers/regulator/max8952.c
> +++ b/drivers/regulator/max8952.c
> @@ -26,7 +26,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/regulator/driver.h>
>  #include <linux/regulator/max8952.h>
> -#include <linux/mutex.h>
>  #include <linux/gpio.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> @@ -47,7 +46,6 @@ enum {
>  struct max8952_data {
>  	struct i2c_client	*client;
>  	struct device		*dev;
> -	struct mutex		mutex;
>  	struct max8952_platform_data *pdata;
>  	struct regulator_dev	*rdev;
>  
> @@ -208,7 +206,6 @@ static int __devinit max8952_pmic_probe(struct i2c_client *client,
>  	max8952->client = client;
>  	max8952->dev = &client->dev;
>  	max8952->pdata = pdata;
> -	mutex_init(&max8952->mutex);
>  
>  	max8952->rdev = regulator_register(&regulator, max8952->dev,
>  			&pdata->reg_data, max8952);

Applied.

Thanks

Liam

