Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2KHU11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:27:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab2KHU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:27:25 -0500
Date: Thu, 8 Nov 2012 12:27:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Daniel Jeong <daniel.jeong@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]backlight: lm3639: fix coccinelle warning.
Message-Id: <20121108122724.d602a134.akpm@linux-foundation.org>
In-Reply-To: <1352357089-4819-1-git-send-email-gshark.jeong@gmail.com>
References: <1352357089-4819-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 Nov 2012 15:44:49 +0900
"G.Shark Jeong" <gshark.jeong@gmail.com> wrote:

> From: "G.Shark Jeong" <gshark.jeong@gmail.com>
> 
> Fix coccinelle warning.

Please always quote the warning or error message text in the changelog
when fixing an error or warning.

> diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
> index 585949b..868a9da 100644
> --- a/drivers/video/backlight/lm3639_bl.c
> +++ b/drivers/video/backlight/lm3639_bl.c
> @@ -403,9 +403,9 @@ static int __devexit lm3639_remove(struct i2c_client *client)
>  
>  	regmap_write(pchip->regmap, REG_ENABLE, 0x00);
>  
> -	if (&pchip->cdev_torch)
> +	if ((&pchip->cdev_torch)!=NULL)
>  		led_classdev_unregister(&pchip->cdev_torch);
> -	if (&pchip->cdev_flash)
> +	if ((&pchip->cdev_flash)!=NULL)

Please use scripts/checkpatch.pl.



This code is just pointless.  The expression "&anything" will never
evaluate to NULL.

