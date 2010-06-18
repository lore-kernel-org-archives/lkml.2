Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab0FRBdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 21:33:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54063 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab0FRBdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 21:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NoLUhXU6VP8vfqi+rzSULrbuxwqwqm+9xYSTwYFgpjUrsEt9CTGBeF6vyOnrBhCw0f
         lDeeKDQSK1YaG5YTVzawyqqxk8mzJEPRG1c5lcnZtYIqz/w1nODp/3vgrmJO0bP4baU1
         kJKol+ZUPnDP/K2R8ZdS5qnfDoHRJlNvtsgco=
Message-ID: <4C1ACCCF.1050605@gmail.com>
Date: Fri, 18 Jun 2010 09:33:03 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Roman Fietze <roman.fietze@telemotive.de>
CC: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [rtc-linux] [PATCH] isl12022: added Intersil ISL12022 RTC
References: <201006171123.31484.roman.fietze@telemotive.de> <AANLkTilPqFdeMLSabEkrwIQieJU0vhLnSBVe5_LH8x0G@mail.gmail.com> <201006171454.07593.roman.fietze@telemotive.de>
In-Reply-To: <201006171454.07593.roman.fietze@telemotive.de>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roman,

> Hallo Wan,
> 
> Thanks for the review. I added an second patch here with the proposed
> changes. Should I better provide an all-in-one patch instead?
> 

Since your patch has not been applied please submit a revised version of
the full patch rather than incremental updates.

> On Thursday 17 June 2010 12:28:11 Wan ZongShun wrote:
> 
>> There is no need to print your private driver info in Kernel, please
>> get rid of it.
> 
> Ok, I thought its good habit, just copied that 1:1 from rtc-pcf8563.c
> as well as the stuff with the check for ->rtc beeing zero and the
> order of the module macros. I can of course also provide a patch for
> rtc-pcf8563.c with the same changes.
> 
> 
> From 134f8488933f723489d5cf244c0b54bde1ce3622 Mon Sep 17 00:00:00 2001
> From: Roman Fietze <roman.fietze@telemotive.de>
> Date: Thu, 17 Jun 2010 14:45:36 +0200
> Subject: [PATCH] rtc-isl12022: omit checking ->rtc in remove function, reorder module macros
> 
> - isl12022->rtc cannot be NULL inside isl12022_remove
> - move up module init and exit macros
> - be less verbose inside probe function
> 

> Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
> ---
>  drivers/rtc/rtc-isl12022.c |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
> index e0a340f..293d2c1 100644
> --- a/drivers/rtc/rtc-isl12022.c
> +++ b/drivers/rtc/rtc-isl12022.c
> @@ -236,8 +236,6 @@ static int isl12022_probe(struct i2c_client *client,
>  
>  	int ret = 0;
>  
> -	dev_dbg(&client->dev, "%s\n", __func__);
> -
>  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
>  		return -ENODEV;
>  
> @@ -245,7 +243,7 @@ static int isl12022_probe(struct i2c_client *client,
>  	if (!isl12022)
>  		return -ENOMEM;
>  
> -	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
> +	dev_dbg(&client->dev, "chip found, driver version " DRV_VERSION "\n");
>  
>  	i2c_set_clientdata(client, isl12022);
>  
> @@ -269,9 +267,7 @@ static int isl12022_remove(struct i2c_client *client)
>  {
>  	struct isl12022 *isl12022 = i2c_get_clientdata(client);
>  
> -	if (isl12022->rtc)
> -		rtc_device_unregister(isl12022->rtc);
> -
> +	rtc_device_unregister(isl12022->rtc);
>  	kfree(isl12022);
>  
>  	return 0;
> @@ -303,10 +299,10 @@ static void __exit isl12022_exit(void)
>  	i2c_del_driver(&isl12022_driver);
>  }
>  
> +module_init(isl12022_init);
> +module_exit(isl12022_exit);
> +
>  MODULE_AUTHOR("roman.fietze@telemotive.de");
>  MODULE_DESCRIPTION("ISL 12022 RTC driver");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION(DRV_VERSION);
> -
> -module_init(isl12022_init);
> -module_exit(isl12022_exit);

