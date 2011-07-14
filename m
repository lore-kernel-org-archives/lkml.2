Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1GNGZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 02:25:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42980 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1GNGZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 02:25:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6406"; a="103448778"
Message-ID: <4E1E8BB8.2060809@codeaurora.org>
Date: Thu, 14 Jul 2011 11:54:56 +0530
From: Anirudh Ghayal <aghayal@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Trilok Soni <tsoni@codeaurora.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: pmic8xxx-keypad - fix a leak of the IRQ during
 init failure
References: <1310609391.14393.1.camel@phoenix>
In-Reply-To: <1310609391.14393.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 7/14/2011 7:39 AM, Axel Lin wrote:
> Make sure we are passing the same cookie in all calls to
> request_any_context_irq() and free_irq().
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>

Acked-by: Anirudh Ghayal <aghayal@codeaurora.org>

> ---
>   drivers/input/keyboard/pmic8xxx-keypad.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
> index 6229c3e..e7cc51d 100644
> --- a/drivers/input/keyboard/pmic8xxx-keypad.c
> +++ b/drivers/input/keyboard/pmic8xxx-keypad.c
> @@ -700,9 +700,9 @@ static int __devinit pmic8xxx_kp_probe(struct platform_device *pdev)
>   	return 0;
>
>   err_pmic_reg_read:
> -	free_irq(kp->key_stuck_irq, NULL);
> +	free_irq(kp->key_stuck_irq, kp);
>   err_req_stuck_irq:
> -	free_irq(kp->key_sense_irq, NULL);
> +	free_irq(kp->key_sense_irq, kp);
>   err_gpio_config:
>   err_get_irq:
>   	input_free_device(kp->input);
> @@ -717,8 +717,8 @@ static int __devexit pmic8xxx_kp_remove(struct platform_device *pdev)
>   	struct pmic8xxx_kp *kp = platform_get_drvdata(pdev);
>
>   	device_init_wakeup(&pdev->dev, 0);
> -	free_irq(kp->key_stuck_irq, NULL);
> -	free_irq(kp->key_sense_irq, NULL);
> +	free_irq(kp->key_stuck_irq, kp);
> +	free_irq(kp->key_sense_irq, kp);
>   	input_unregister_device(kp->input);
>   	kfree(kp);
>

