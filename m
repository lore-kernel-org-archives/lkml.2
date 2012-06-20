Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2FTHI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:08:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56880 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab2FTHI1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:08:27 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340169651-7844-1-git-send-email-yadi.brar@samsung.com>
References: <1340169651-7844-1-git-send-email-yadi.brar@samsung.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 20 Jun 2012 15:08:06 +0800
Message-ID: <CAF+7xWmfUd0cHVijJZcQDbU-Qm_rqPwe8GbKok0Vsr37V8CoYA@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: max77686: Implement .set_ramp_delay() callback.
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/20 Yadwinder Singh Brar <yadi.brar01@gmail.com>:
> This patch implements the .set_ramp_delay callback to set the ramp_delay on
> hardware for BUCK2/3/4 if ramp_delay is set in regulator constraints.
>
> This patch also do some cleaning work for unrequired members of
> struct max77686_data.
>
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  drivers/regulator/max77686.c |   37 +++++++++++++++++++++++++++++--------
>  1 files changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index a29eee3..5c2a32f 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -65,11 +65,34 @@ enum max77686_ramp_rate {
>  };
>
>  struct max77686_data {
> -       struct device *dev;
> -       struct max77686_dev *iodev;
>        struct regulator_dev **rdev;
>  };
>
> +static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> +{
> +       unsigned int ramp_value = RAMP_RATE_NO_CTRL;
> +
> +       switch (ramp_delay) {
> +       case 1 ... 13750:
> +               ramp_value = RAMP_RATE_13P75MV;
> +               break;
> +       case 13751 ... 27500:
> +               ramp_value = RAMP_RATE_27P5MV;
> +               break;
> +       case 27501 ... 55000:
> +               ramp_value = RAMP_RATE_55MV;
> +               break;
> +       case 55001 ... 100000:
> +               break;
> +       default:
> +               pr_warn("%s: ramp_delay: %d not supported, setting 100000\n",
> +                       rdev->desc->name, ramp_delay);
Hi Yadwinder,
I'm a bit confused about this default setting.
If set_ramp_delay() is not called, the default setting for BUCK234 is
MAX77686_DVS_RAMP_DELAY (27500 uV/uS).
So why you set default to 100000 here.

Regards,
Axel
