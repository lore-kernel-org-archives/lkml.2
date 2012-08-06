Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab2HFErx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 00:47:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35476 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab2HFEru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 00:47:50 -0400
MIME-Version: 1.0
In-Reply-To: <002c01cd738e$14a880b0$3df98210$%han@samsung.com>
References: <002c01cd738e$14a880b0$3df98210$%han@samsung.com>
Date: Mon, 6 Aug 2012 10:17:49 +0530
Message-ID: <CAK9yfHyw=6-e28mHrhyhTuC2uykeqQzpsGRfXcWmcaON=NvcPw@mail.gmail.com>
Subject: Re: [PATCH 1/3] backlight: da9052: Use usleep_range() instead of
 msleep() for small sleeps
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

On 6 August 2012 10:13, Jingoo Han <jg1.han@samsung.com> wrote:
> Since msleep might not sleep for the desired amount when less
> than 20ms, use usleep_range.
>
> Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/da9052_bl.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
> index b628d68..10485c9 100644
> --- a/drivers/video/backlight/da9052_bl.c
> +++ b/drivers/video/backlight/da9052_bl.c
> @@ -72,7 +72,7 @@ static int da9052_adjust_wled_brightness(struct da9052_bl *wleds)
>         if (ret < 0)
>                 return ret;
>
> -       msleep(10);
> +       usleep_range(10000, 11000);

Can't we just use usleep(10000) instead?


>
>         if (wleds->brightness) {
>                 ret = da9052_reg_write(wleds->da9052, wled_bank[wleds->led_reg],
> --
> 1.7.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With warm regards,
Sachin
