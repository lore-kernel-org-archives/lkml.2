Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2LLG1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:27:06 -0500
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:54499 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862Ab2LLG1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:27:04 -0500
Message-ID: <50C82392.80607@marvell.com>
Date: Wed, 12 Dec 2012 14:26:26 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        Qiao Zhou <zhouqiao@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] onkey: 88pm80x: update irq base
References: <1354513326-21026-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1354513326-21026-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2012 06:26:03.0532 (UTC) FILETIME=[8F737CC0:01CDD831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 01:42 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> irq base is stored in 88pm80x's drv data, we need to add irq
> base to get the correct irq num
>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/input/misc/88pm80x_onkey.c |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/input/misc/88pm80x_onkey.c b/drivers/input/misc/88pm80x_onkey.c
> index 7f26e7b..cc352f9 100644
> --- a/drivers/input/misc/88pm80x_onkey.c
> +++ b/drivers/input/misc/88pm80x_onkey.c
> @@ -67,7 +67,7 @@ static int __devinit pm80x_onkey_probe(struct platform_device *pdev)
>   
>   	struct pm80x_chip *chip = dev_get_drvdata(pdev->dev.parent);
>   	struct pm80x_onkey_info *info;
> -	int err;
> +	int irq, err;
>   
>   	info = kzalloc(sizeof(struct pm80x_onkey_info), GFP_KERNEL);
>   	if (!info)
> @@ -75,13 +75,14 @@ static int __devinit pm80x_onkey_probe(struct platform_device *pdev)
>   
>   	info->pm80x = chip;
>   
> -	info->irq = platform_get_irq(pdev, 0);
> -	if (info->irq < 0) {
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
>   		dev_err(&pdev->dev, "No IRQ resource!\n");
>   		err = -EINVAL;
>   		goto out;
>   	}
>   
> +	info->irq = irq + chip->irq_base;
>   	info->map = info->pm80x->regmap;
>   	if (!info->map) {
>   		dev_err(&pdev->dev, "no regmap!\n");


Samuel,

Could you help to review my patch? Thanks a lot!

Qing

