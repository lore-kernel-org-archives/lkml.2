Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab2LLG1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:27:17 -0500
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:54701 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab2LLG1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:27:15 -0500
Message-ID: <50C823B6.2040301@marvell.com>
Date: Wed, 12 Dec 2012 14:27:02 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Qiao Zhou <zhouqiao@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 4/4] rtc: 88pm80x: update irq base
References: <1354513427-21266-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1354513427-21266-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2012 06:26:39.0188 (UTC) FILETIME=[A4B42940:01CDD831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 01:43 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> irq base is stored in 88pm80x's drv data, we need to add irq
> base to get the correct irq num
>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/rtc/rtc-88pm80x.c |    7 ++++---
>   1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
> index 6367984..7c3a264 100644
> --- a/drivers/rtc/rtc-88pm80x.c
> +++ b/drivers/rtc/rtc-88pm80x.c
> @@ -256,7 +256,7 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
>   	struct pm80x_rtc_info *info;
>   	struct rtc_time tm;
>   	unsigned long ticks = 0;
> -	int ret;
> +	int irq, ret;
>   
>   	pdata = pdev->dev.platform_data;
>   	if (pdata == NULL)
> @@ -266,12 +266,13 @@ static int __devinit pm80x_rtc_probe(struct platform_device *pdev)
>   	    devm_kzalloc(&pdev->dev, sizeof(struct pm80x_rtc_info), GFP_KERNEL);
>   	if (!info)
>   		return -ENOMEM;
> -	info->irq = platform_get_irq(pdev, 0);
> -	if (info->irq < 0) {
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
>   		dev_err(&pdev->dev, "No IRQ resource!\n");
>   		ret = -EINVAL;
>   		goto out;
>   	}
> +	info->irq = irq + chip->irq_base;
>   
>   	info->chip = chip;
>   	info->map = chip->regmap;


Samuel,

Could you help to review my patch? Thanks a lot!

Qing

