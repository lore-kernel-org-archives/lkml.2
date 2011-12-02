Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380Ab1LBC1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:27:12 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52903 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1LBC1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:27:11 -0500
MIME-Version: 1.0
In-Reply-To: <1322554671-16312-1-git-send-email-jhbird.choi@samsung.com>
References: <1322554671-16312-1-git-send-email-jhbird.choi@samsung.com>
Date: Fri, 2 Dec 2011 11:27:11 +0900
X-Google-Sender-Auth: EurgK6YQS8UTc-Flh97JGPlh13Q
Message-ID: <CAH9JG2X8tH9j9MdXxb2Binu6vAD0oH76vbxm27b7RDMQ-8o=gw@mail.gmail.com>
Subject: Re: [PATCH] mfd: max8998: Use standard device wakeup for handling
 wakeup device
From: Kyungmin Park <kyungmin.park@samsung.com>
To: jhbird.choi@samsung.com,
        =?UTF-8?B?7ZWo66qF7KO8?= <myungjoo.ham@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, jhbird.choi@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

After this patch, we don't more use the max8998->wakeup field, so it
can remove it
and use & set the wakeup feature with pdata->wakeup.

device_init_wakeup(max8998->dev, pdata->wakeup);

On 11/29/11, jhbird.choi@samsung.com <jhbird.choi@samsung.com> wrote:
> From: Jonghwan Choi <jhbird.choi@samsung.com>
>
> Use device_init_wakeup & device_may_wakeup to init wakeup
>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/mfd/max8998.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
> index de4096a..6ef56d2 100644
> --- a/drivers/mfd/max8998.c
> +++ b/drivers/mfd/max8998.c
> @@ -176,6 +176,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
>  	if (ret < 0)
>  		goto err;
>
> +	device_init_wakeup(max8998->dev, max8998->wakeup);
> +
>  	return ret;
>
>  err:
> @@ -210,7 +212,7 @@ static int max8998_suspend(struct device *dev)
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>  	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
>
> -	if (max8998->wakeup)
> +	if (device_may_wakeup(dev))
>  		irq_set_irq_wake(max8998->irq, 1);
>  	return 0;
>  }
> @@ -220,7 +222,7 @@ static int max8998_resume(struct device *dev)
>  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
>  	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
>
> -	if (max8998->wakeup)
> +	if (device_may_wakeup(dev))
>  		irq_set_irq_wake(max8998->irq, 0);
>  	/*
>  	 * In LP3974, if IRQ registers are not "read & clear"
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
