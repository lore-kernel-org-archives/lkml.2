Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1C3QhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:37:03 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33203 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab1C3QhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:37:00 -0400
Message-ID: <4D935C56.4060903@metafoo.de>
Date: Wed, 30 Mar 2011 18:37:42 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Nicolas Kaiser <nikai@nikai.net>
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/rtc-jz4740.c: fix error check
References: <20110330181201.29e473bf@absol.kitzblitz>
In-Reply-To: <20110330181201.29e473bf@absol.kitzblitz>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 06:12 PM, Nicolas Kaiser wrote:
> Checking 'rtc->irq < 0' doesn't work because 'rtc->irq' is unsigned.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>

But while were at it we should change it, so that the result of
platform_get_irq becomes the return value in case of an error instead of using
the wrong or at least confusing -ENOENT.

> ---
> Untested.
> 
>  drivers/rtc/rtc-jz4740.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
> index b647363..ba91bc6 100644
> --- a/drivers/rtc/rtc-jz4740.c
> +++ b/drivers/rtc/rtc-jz4740.c
> @@ -220,12 +220,13 @@ static int __devinit jz4740_rtc_probe(struct platform_device *pdev)
>  	if (!rtc)
>  		return -ENOMEM;
>  
> -	rtc->irq = platform_get_irq(pdev, 0);
> -	if (rtc->irq < 0) {
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
>  		ret = -ENOENT;
>  		dev_err(&pdev->dev, "Failed to get platform irq\n");
>  		goto err_free;
>  	}
> +	rtc->irq = ret;
>  
>  	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!rtc->mem) {

