Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab1KRQyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:54:35 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:44628 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab1KRQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:54:34 -0500
Date: Fri, 18 Nov 2011 17:54:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] I2C: Make i2cdev_notifier_call static
Message-ID: <20111118175425.77941c9a@endymion.delvare>
In-Reply-To: <1321631251-4438-1-git-send-email-shubhrajyoti@ti.com>
References: <1321631251-4438-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 21:17:31 +0530, Shubhrajyoti D wrote:
> The function i2cdev_notifier_call is used only in i2c-dev file
> making it static.
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

Applied, thanks.

-- 
Jean Delvare
