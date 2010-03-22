Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab0CVRIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:08:14 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:34635 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752770Ab0CVRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:08:12 -0400
Date: Mon, 22 Mar 2010 20:08:10 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ryan Mallon <ryan@bluewatersys.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 02/24] power/ds2782: really clear i2c_clientdata on exit
Message-ID: <20100322170810.GA30325@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de>
 <1269094385-16114-3-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1269094385-16114-3-git-send-email-w.sang@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 03:12:43PM +0100, Wolfram Sang wrote:
> Probably due to a copy & paste bug, clientdata was set again to the data
> structure (which is freed immediately afterwards) when it should be NULLed.
> 
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
[...]
> -	i2c_set_clientdata(client, info);
> +	i2c_set_clientdata(client, NULL);

Why is this needed? I'd vote for just removing set_clientdata in
fail/remove paths.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
