Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab2LLHOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 02:14:30 -0500
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:52613 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862Ab2LLHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 02:14:29 -0500
Message-ID: <50C82371.7040808@marvell.com>
Date: Wed, 12 Dec 2012 14:25:53 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mfd: 88pm80x: move to regmap irq base implementation
References: <1354513245-20775-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1354513245-20775-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2012 06:25:29.0360 (UTC) FILETIME=[7B154100:01CDD831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 01:40 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> get irq_base for mfd sub-device
>
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/mfd/88pm800.c       |    2 +-
>   drivers/mfd/88pm805.c       |    1 +
>   include/linux/mfd/88pm80x.h |    1 +
>   3 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
> index 73b2c9f..e1525ab 100644
> --- a/drivers/mfd/88pm800.c
> +++ b/drivers/mfd/88pm800.c
> @@ -343,7 +343,7 @@ static int __devinit device_irq_init_800(struct pm80x_chip *chip)
>   	ret =
>   	    regmap_add_irq_chip(chip->regmap, chip->irq, flags, -1,
>   				chip->regmap_irq_chip, &chip->irq_data);
> -
> +	chip->irq_base = regmap_irq_chip_get_base(chip->irq_data);
>   out:
>   	return ret;
>   }
> diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
> index 7878013..8c9e25a 100644
> --- a/drivers/mfd/88pm805.c
> +++ b/drivers/mfd/88pm805.c
> @@ -168,6 +168,7 @@ static int __devinit device_irq_init_805(struct pm80x_chip *chip)
>   	ret =
>   	    regmap_add_irq_chip(chip->regmap, chip->irq, flags, -1,
>   				chip->regmap_irq_chip, &chip->irq_data);
> +	chip->irq_base = regmap_irq_chip_get_base(chip->irq_data);
>   out:
>   	return ret;
>   }
> diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
> index a0ca0dc..904efb9 100644
> --- a/include/linux/mfd/88pm80x.h
> +++ b/include/linux/mfd/88pm80x.h
> @@ -303,6 +303,7 @@ struct pm80x_chip {
>   	int id;
>   	int irq;
>   	int irq_mode;
> +	int irq_base;
>   	unsigned long wu_flag;
>   	spinlock_t lock;
>   };


Samuel,

Could you help to review my patch? Thanks a lot!

Qing


