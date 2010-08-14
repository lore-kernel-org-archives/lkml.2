Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0HNRvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:51:13 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:44876 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0HNRvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:51:12 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Aug 2010 13:51:12 EDT
Date: Sat, 14 Aug 2010 19:51:04 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia@diku.dk>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH 27/42] drivers/hwmon: Adjust confusing if 
 indentation
Message-ID: <20100814195104.5dff8cbe@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.64.1008052224500.31692@ask.diku.dk>
References: <Pine.LNX.4.64.1008052224500.31692@ask.diku.dk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Aug 2010 22:25:06 +0200 (CEST), Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The if (ret) test has no effect if the if branch is not taken, so move it
> into the branch that it is already aligned with.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r disable braces4@
> position p1,p2;
> statement S1,S2;
> @@
> 
> (
> if (...) { ... }
> |
> if (...) S1@p1 S2@p2
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> if (p1[0].column == p2[0].column):
>   cocci.print_main("branch",p1)
>   cocci.print_secs("after",p2)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/hwmon/mc13783-adc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/hwmon/mc13783-adc.c b/drivers/hwmon/mc13783-adc.c
> index ce3c7bc..0b53713 100644
> --- a/drivers/hwmon/mc13783-adc.c
> +++ b/drivers/hwmon/mc13783-adc.c
> @@ -162,10 +162,11 @@ static int __init mc13783_adc_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_err_create1;
>  
> -	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN))
> +	if (!(priv->mc13783->flags & MC13783_USE_TOUCHSCREEN)) {
>  		ret = sysfs_create_group(&pdev->dev.kobj, &mc13783_group_ts);
>  		if (ret)
>  			goto out_err_create2;
> +	}
>  
>  	priv->hwmon_dev = hwmon_device_register(&pdev->dev);
>  	if (IS_ERR(priv->hwmon_dev)) {

Already fixed by this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=eaf06ee22594ac90cdd0279483b06c1db1667e01

-- 
Jean Delvare
