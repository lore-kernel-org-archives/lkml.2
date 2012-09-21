Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab2IUXy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 19:54:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63355 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2IUXy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 19:54:27 -0400
Date: Fri, 21 Sep 2012 16:51:44 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: dwmw2@infradead.org, philipp.zabel@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pda_power: remove ac_draw_failed goto and label
Message-ID: <20120921235144.GC26715@lizard>
References: <505BBB4B.3060508@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <505BBB4B.3060508@yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:56:43AM +0100, Paul Parsons wrote:
> A previous patch added the ac_draw_failed goto and label to
> pda_power_probe(). The goto would be invoked after a failed call to
> regulator_get().
> 
> However the way ac_draw is used - always after a check for NULL -
> suggests that a failed call to regulator_get() was not fatal.
> 
> This patch removes the ac_draw_failed goto and label, partly reverting
> the previous patch.
> 
> This patch also removes the assignment of an error code to ret after a
> failed call to regulator_get(), since the error code is now never used.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/power/pda_power.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index d3be834d..7df7c5f 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -284,9 +284,7 @@ static int pda_power_probe(struct platform_device *pdev)
>  	ac_draw = regulator_get(dev, "ac_draw");
>  	if (IS_ERR(ac_draw)) {
>  		dev_dbg(dev, "couldn't get ac_draw regulator\n");
> -		ret = PTR_ERR(ac_draw);
>  		ac_draw = NULL;
> -		goto ac_draw_failed;

For some reason you have a bit different code, so your patch is not based
on the battery tree. (In my tree ret and ac_draw assignments are swapped.)
Maybe that's because I had to manually redo your first patch...

Anyway, I repeated your patch by hand again and thus applied it.

Thank you!

>  	}
> 
>  	update_status();
> @@ -416,7 +414,6 @@ ac_supply_failed:
>  		regulator_put(ac_draw);
>  		ac_draw = NULL;
>  	}
> -ac_draw_failed:
>  	if (pdata->exit)
>  		pdata->exit(dev);
>  init_failed:
> -- 
> 1.7.8.6
