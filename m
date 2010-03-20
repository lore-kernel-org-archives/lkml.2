Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab0CTWAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 18:00:39 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:25841 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751597Ab0CTWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 18:00:37 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Mar 2010 18:00:37 EDT
Message-ID: <4BA543F1.6080504@bluewatersys.com>
Date: Sun, 21 Mar 2010 10:53:53 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 02/24] power/ds2782: really clear i2c_clientdata on exit
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-3-git-send-email-w.sang@pengutronix.de>
In-Reply-To: <1269094385-16114-3-git-send-email-w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang wrote:
> Probably due to a copy & paste bug, clientdata was set again to the data
> structure (which is freed immediately afterwards) when it should be NULLed.

Good catch. Thanks.

Acked-by: Ryan Mallon <ryan@bluewatersys.com>

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Ryan Mallon <ryan@bluewatersys.com>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> ---
>  drivers/power/ds2782_battery.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index da14f37..6971b85 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -236,7 +236,7 @@ static int ds2782_battery_remove(struct i2c_client *client)
>  	idr_remove(&battery_id, info->id);
>  	mutex_unlock(&battery_lock);
>  
> -	i2c_set_clientdata(client, info);
> +	i2c_set_clientdata(client, NULL);
>  
>  	kfree(info);
>  	return 0;
> @@ -289,7 +289,7 @@ static int ds2782_battery_probe(struct i2c_client *client,
>  fail_register:
>  	kfree(info->battery.name);
>  fail_name:
> -	i2c_set_clientdata(client, info);
> +	i2c_set_clientdata(client, NULL);
>  	kfree(info);
>  fail_info:
>  	mutex_lock(&battery_lock);

