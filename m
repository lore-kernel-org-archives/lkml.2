Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab1H3MxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:53:02 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27923 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1H3Mw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:52:58 -0400
Date: Tue, 30 Aug 2011 14:52:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video/backlight: Remove obsolete cleanup for clientdata
Message-ID: <20110830145248.6a3b97ef@endymion.delvare>
In-Reply-To: <1314269652-18702-1-git-send-email-w.sang@pengutronix.de>
References: <1314269652-18702-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 12:54:12 +0200, Wolfram Sang wrote:
> A few new i2c-drivers came into the kernel which clear the clientdata-pointer
> on exit or error. This is obsolete meanwhile, the core will do it.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Richard Purdie <rpurdie@rpsys.net>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/video/backlight/adp8870_bl.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
> index 05a8832..71d90f4 100644
> --- a/drivers/video/backlight/adp8870_bl.c
> +++ b/drivers/video/backlight/adp8870_bl.c
> @@ -932,7 +932,6 @@ out:
>  out1:
>  	backlight_device_unregister(bl);
>  out2:
> -	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  
>  	return ret;
> @@ -952,7 +951,6 @@ static int __devexit adp8870_remove(struct i2c_client *client)
>  			&adp8870_bl_attr_group);
>  
>  	backlight_device_unregister(data->bl);
> -	i2c_set_clientdata(client, NULL);
>  	kfree(data);
>  
>  	return 0;

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
