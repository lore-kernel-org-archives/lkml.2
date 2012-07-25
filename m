Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab2GYGTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:19:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38871 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736Ab2GYGTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:19:04 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-8c-500f8fd76147
Message-id: <500F8FD9.1080601@samsung.com>
Date: Wed, 25 Jul 2012 15:19:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Lockwood <lockwood@android.com>
Subject: Re: [PATCH] extcon: extcon_gpio: Replace gpio_request_one by
 devm_gpio_request_one
References: <1343093217.7556.1.camel@phoenix>
In-reply-to: <1343093217.7556.1.camel@phoenix>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAd3r/fwBBl1rFS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzMcr2QtOsFec3vSAtYFxClsXIyeHhICJxJuWG4wQtpjEhXvr
	geJcHEICixglHszqBCsSEuhiklhwMh3E5hXQkvg0/SkziM0ioCox+etKsBo2oPj+FzeAbA4O
	UYEIiV/9HBDlghI/Jt9jAbFFBBQl+t89ZAeZzyywhFHiUd8HVpCEsECsxMUNW6B26Uoc2v8G
	zOYU0JNYs/4RWDOzgLrEpHmLmCFseYnNa94yT2AUmIVkxywkZbOQlC1gZF7FKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERyAz6R2MK5ssDjEKMDBqMTD+/MJX4AQa2JZcWXuIUYJDmYlEd6i
	MP4AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzG3l/9hQTSE0tSs1NTC1KLYLJMHJxSDYwtbSYf
	g8xCPCzOnk75/Z15tozm8V/TZnDYid5ROf5Z5XxR//O0peX7Zworb9uh4dfPmLf/s+1eu2d/
	zydwv599bMXZiDSj5XGBTvq83scXpur4/2Q7JrwyU7RGXln4S8ZXNpulSk/d/1evO1dxyyBp
	/8SZXKv3nA87vc5e3NNhetnX7LtxbYVKLMUZiYZazEXFiQAYKVMwPAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 10:26 AM, Axel Lin wrote:

> commit 01eaf24 "extcon: Convert extcon_gpio to devm_gpio_request_one"
> missed the replacement for devm_gpio_request_one. fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/extcon/extcon_gpio.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon_gpio.c b/drivers/extcon/extcon_gpio.c
> index fe3db45..3cc152e 100644
> --- a/drivers/extcon/extcon_gpio.c
> +++ b/drivers/extcon/extcon_gpio.c
> @@ -107,7 +107,8 @@ static int __devinit gpio_extcon_probe(struct platform_device *pdev)
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = gpio_request_one(extcon_data->gpio, GPIOF_DIR_IN, pdev->name);
> +	ret = devm_gpio_request_one(&pdev->dev, extcon_data->gpio, GPIOF_DIR_IN,
> +				    pdev->name);
>  	if (ret < 0)
>  		goto err;
>  

It is right.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

Thank you,
Chanwoo Choi
