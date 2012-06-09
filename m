Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab2FIEUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 00:20:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40961 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2FIEUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 00:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <1339147304.5216.1.camel@phoenix>
References: <1339147304.5216.1.camel@phoenix>
Date: Sat, 9 Jun 2012 09:50:18 +0530
Message-ID: <CAKew6eXDCXsfmU3WA_GdGUYQPCxDwPfrJN4zOeNAPGoCSHKbkQ@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: max77686: Fix the delay time for set_voltage_time_sel
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 2:51 PM, Axel Lin <axel.lin@gmail.com> wrote:
> rdev->desc->uV_step * abs(new_selector - old_selector) returns uV.
> The unit of ramp_rate is mV/us.
> Thus 1000 should be multiplied.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/max77686.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
> index b76a038..10bf65a 100644
> --- a/drivers/regulator/max77686.c
> +++ b/drivers/regulator/max77686.c
> @@ -78,7 +78,7 @@ static int max77686_set_dvs_voltage_time_sel(struct regulator_dev *rdev,
>
>        return DIV_ROUND_UP(rdev->desc->uV_step *
>                            abs(new_selector - old_selector),
> -                           ramp_rate[max77686->ramp_delay]);
> +                           ramp_rate[max77686->ramp_delay] * 1000);
>  }
>
>  static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
> @@ -86,7 +86,7 @@ static int max77686_set_voltage_time_sel(struct regulator_dev *rdev,
>  {
>        /* Unconditionally 100 mV/us */
>        return DIV_ROUND_UP(rdev->desc->uV_step *
> -                           abs(new_selector - old_selector), 100);
> +                           abs(new_selector - old_selector), 100 * 1000);
>  }
>
>  static struct regulator_ops max77686_ops = {
> --

Reviewed-by: Yadwinder Singh Brar <yadi.brar@samsung.com>

Thanks,
Yadwinder.
