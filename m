Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2HGJOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:14:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44322 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2HGJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:14:20 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-f4-5020dc6b6f1d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kim, Milo'" <Milo.Kim@ti.com>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004001cd73b6$c011da50$40358ef0$%han@samsung.com>
 <A874F61F95741C4A9BA573A70FE3998FEBF3@DQHE02.ent.ti.com>
In-reply-to: <A874F61F95741C4A9BA573A70FE3998FEBF3@DQHE02.ent.ti.com>
Subject: Re: [PATCH 3/3] backlight: lp855x: remove goto err_dev
Date: Tue, 07 Aug 2012 18:14:18 +0900
Message-id: <000001cd747d$0658f680$130ae380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1ztr/7coLsb16/SeONd+CmjHJZPQAvsEsAAAHP72A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAd3sOwoBBg0fuSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG3m+3mQpu8FTsurGFsYHxM2cXIweHhICJxNoril2MnECmmMSF
	e+vZuhi5OIQEFjFK/GuYzgThzGaSWLK7gQWkik1ATeLLl8PsILaIgLLE8p9HwTqYBZYwStx5
	vIkJZKqQQIXEhQ02IDWcAq4STza8YwOxhQXsJXac6mUFsVkEVCU293Uygdi8ArYSC7esYIGw
	BSV+TL4HZjMLaEms33mcCcKWl9i85i0zxNHqEo/+6kKcYCUx+80DZogSEYl9L94xTmAUmoVk
	0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFh/Ex6B+OqBotDjAIc
	jEo8vDNVFAKEWBPLiitzDzFKcDArifAe3gkU4k1JrKxKLcqPLyrNSS0+xCjNwaIkzmvi/dVf
	SCA9sSQ1OzW1ILUIJsvEwSnVwKjE/Zt5tZhIuddU88fCH9xNk51evGTdw87oP5Gty+bLtzk9
	MpYK8x6/NX6wxPiqxYMwWTUXnqp/vfzmj5/eXPVAPWbf9leHzNaGX+hZenpvZ9Hv1T5udQpl
	bJJCr8qWpebe4dE+c02sJ+38FeY+z+PL8n+8r+3eVfuqh93Gok9D5/xNNdt9L5VYijMSDbWY
	i4oTAcwWbY9fAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 07, 2012 5:32 PM Kim, Milo wrote:
> 
> > This patch removes goto err_dev, which makes code a bit smaller.
> 
> Thanks !
> IMO, goto statements are meaningful on _probe().
> However, 'goto err_sysfs' also can be removed if the size of code is critical.

OK, I will send v2 patch.

Best regards,
Jingoo Han

> 
> drivers/video/backlight/lp855x_bl.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
> index 72a0e0c..7e4198c 100644
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -268,29 +268,25 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
>  	if (ret) {
>  		dev_err(lp->dev, "i2c communication err: %d", ret);
>  		if (mode == REGISTER_BASED)
> -			goto err_dev;
> +			return ret;
>  	}
> 
>  	ret = lp855x_backlight_register(lp);
>  	if (ret) {
>  		dev_err(lp->dev,
>  			"failed to register backlight. err: %d\n", ret);
> -		goto err_dev;
> +		return ret;
>  	}
> 
>  	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
>  	if (ret) {
>  		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
> -		goto err_sysfs;
> +		lp855x_backlight_unregister(lp);
> +		return ret;
>  	}
> 
>  	backlight_update_status(lp->bl);
>  	return 0;
> -
> -err_sysfs:
> -	lp855x_backlight_unregister(lp);
> -err_dev:
> -	return ret;
>  }
> 
>  static int __devexit lp855x_remove(struct i2c_client *cl)
> --
> 1.7.2.5
> 
> Best Regards,
> Milo


