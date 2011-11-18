Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1KRJn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:43:26 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:42189 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab1KRJnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:43:25 -0500
Date: Fri, 18 Nov 2011 10:43:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] I2C: Make i2cdev_detach_adapter static
Message-ID: <20111118104317.7d150bab@endymion.delvare>
In-Reply-To: <1321605731-3098-1-git-send-email-shubhrajyoti@ti.com>
References: <1321605731-3098-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 14:12:11 +0530, Shubhrajyoti D wrote:
> The function i2cdev_detach_adapter is used only in i2c-dev file
> making it static.

This description doesn't match what the patch actually does. Please
resubmit with proper subject and description.

> Also removes the following sparse warning
> 
> drivers/i2c/i2c-dev.c:582:5: warning: symbol 'i2cdev_notifier_call'
> was not declared. Should it be static?
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/i2c/i2c-dev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> index c90ce50..57a45ce 100644
> --- a/drivers/i2c/i2c-dev.c
> +++ b/drivers/i2c/i2c-dev.c
> @@ -579,7 +579,7 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
>  	return 0;
>  }
>  
> -int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
> +static int i2cdev_notifier_call(struct notifier_block *nb, unsigned long action,
>  			 void *data)
>  {
>  	struct device *dev = data;


-- 
Jean Delvare
