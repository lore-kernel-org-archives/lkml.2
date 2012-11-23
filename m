Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab2KWHSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 02:18:55 -0500
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:57663 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524Ab2KWHSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 02:18:54 -0500
Message-ID: <50AF23AB.3010002@marvell.com>
Date: Fri, 23 Nov 2012 15:20:11 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Qing Xu <qingx@marvell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>
Subject: Re: [PATCH 3/7] mfd: max8925: fix onkey driver irq base
References: <1352187570-9803-1-git-send-email-qingx@marvell.com>
In-Reply-To: <1352187570-9803-1-git-send-email-qingx@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 07:18:48.0640 (UTC) FILETIME=[C8276400:01CDC94A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 03:39 PM, Qing Xu wrote:
> From: Qing Xu <qingx@marvell.com>
>
> update onkey driver's irq base, it should get from max8925,
> but not save in a private value
>
> Signed-off-by: Qing Xu <qingx@marvell.com>
> ---
>   drivers/input/misc/max8925_onkey.c |    3 ---
>   drivers/mfd/max8925-core.c         |    2 +-
>   2 files changed, 1 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
> index 0a12b74..6527789 100644
> --- a/drivers/input/misc/max8925_onkey.c
> +++ b/drivers/input/misc/max8925_onkey.c
> @@ -100,9 +100,6 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
>   	input->dev.parent = &pdev->dev;
>   	input_set_capability(input, EV_KEY, KEY_POWER);
>   
> -	irq[0] += chip->irq_base;
> -	irq[1] += chip->irq_base;
> -
>   	error = request_threaded_irq(irq[0], NULL, max8925_onkey_handler,
>   				     IRQF_ONESHOT, "onkey-down", info);
>   	if (error < 0) {
> diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
> index b1eacae..37a372d 100644
> --- a/drivers/mfd/max8925-core.c
> +++ b/drivers/mfd/max8925-core.c
> @@ -881,7 +881,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
>   
>   	ret = mfd_add_devices(chip->dev, 0, &onkey_devs[0],
>   			      ARRAY_SIZE(onkey_devs),
> -			      NULL, 0, NULL);
> +			      NULL, chip->irq_base, NULL);
>   	if (ret < 0) {
>   		dev_err(chip->dev, "Failed to add onkey subdev\n");
>   		goto out_dev;
Hi Dmitry,

Could you help to review my patch? Thanks a lot!

-Qing

