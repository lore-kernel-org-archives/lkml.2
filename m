Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227Ab2LLGlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 01:41:06 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33680 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab2LLGlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 01:41:05 -0500
Message-ID: <50C82402.3000500@marvell.com>
Date: Wed, 12 Dec 2012 14:28:18 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: Qiao Zhou <zhouqiao@marvell.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Xiaofan Tian <tianxf@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: 88pm80x: fix no interrupt mask reg
References: <1354522285-7563-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1354522285-7563-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2012 06:27:55.0844 (UTC) FILETIME=[D264F040:01CDD831]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 04:11 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> 1.88pm80x do not have interrupt mask registers and we use
> interrupt enable register. So we need to set mask_invert flag.
> 2.add support for D0 version
>
> Signed-off-by: Xiaofan Tian <tianxf@marvell.com>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/mfd/88pm800.c |    4 +++-
>   drivers/mfd/88pm805.c |    1 +
>   2 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
> index e1525ab..3fcc8dd 100644
> --- a/drivers/mfd/88pm800.c
> +++ b/drivers/mfd/88pm800.c
> @@ -119,7 +119,8 @@ enum {
>   	PM800_CHIP_A1  = 0x61,
>   	PM800_CHIP_B0  = 0x62,
>   	PM800_CHIP_C0  = 0x63,
> -	PM800_CHIP_END = PM800_CHIP_C0,
> +	PM800_CHIP_D0  = 0x64,
> +	PM800_CHIP_END = PM800_CHIP_D0,
>   
>   	/* Make sure to update this to the last stepping */
>   	PM8XXX_CHIP_END = PM800_CHIP_END
> @@ -362,6 +363,7 @@ static struct regmap_irq_chip pm800_irq_chip = {
>   	.status_base = PM800_INT_STATUS1,
>   	.mask_base = PM800_INT_ENA_1,
>   	.ack_base = PM800_INT_STATUS1,
> +	.mask_invert = 1,
>   };
>   
>   static int pm800_pages_init(struct pm80x_chip *chip)
> diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
> index 8c9e25a..39a91bd 100644
> --- a/drivers/mfd/88pm805.c
> +++ b/drivers/mfd/88pm805.c
> @@ -187,6 +187,7 @@ static struct regmap_irq_chip pm805_irq_chip = {
>   	.status_base = PM805_INT_STATUS1,
>   	.mask_base = PM805_INT_MASK1,
>   	.ack_base = PM805_INT_STATUS1,
> +	.mask_invert = 1,
>   };
>   
>   static int __devinit device_805_init(struct pm80x_chip *chip)


Samuel,

Could you help to review my patch? Thanks a lot!

Qing


