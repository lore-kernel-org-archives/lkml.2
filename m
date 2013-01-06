Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3AFClF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 21:41:05 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45068 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3AFClD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 21:41:03 -0500
Date: Sat, 5 Jan 2013 18:37:30 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, patches@linaro.org
Subject: Re: [PATCH] power: 88pm860x_battery: Add a few more devm_* APIs
Message-ID: <20130106023730.GA6919@lizard.sbx05280.losalca.wayport.net>
References: <1353674512-16119-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353674512-16119-1-git-send-email-tushar.behera@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 06:11:52PM +0530, Tushar Behera wrote:
> Add devm_* APIs for threaded IRQ.
> 
> Also since devres managed objects are removed when the device gets
> detached, remove explicit freeing of them.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
[...]
> @@ -994,9 +988,6 @@ static int __devexit pm860x_battery_remove(struct platform_device *pdev)
>  	struct pm860x_battery_info *info = platform_get_drvdata(pdev);
>  
>  	power_supply_unregister(&info->battery);
> -	free_irq(info->irq_batt, info);
> -	free_irq(info->irq_cc, info);
> -	kfree(info);

It is not safe to access battery ('struct power_supply') object after
_unregister() (and irq handlers will surely do). Instead of removing
free_irq(), you should place the two calls before _unregister().

Thanks,

>  	platform_set_drvdata(pdev, NULL);
>  	return 0;
>  }
> -- 
> 1.7.4.1
