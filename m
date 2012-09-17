Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab2IQUYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:24:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21693 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab2IQUYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:24:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6838"; a="237766505"
Message-ID: <505786F9.6070208@codeaurora.org>
Date: Mon, 17 Sep 2012 13:24:25 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: David Brown <davidb@codeaurora.org>, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org
Subject: Re: [weiyj.lk@gmail.com: [PATCH] gpio_msm: using for_each_set_bit
 to simplify the code]
References: <20120917155006.GA12316@codeaurora.org>
In-Reply-To: <20120917155006.GA12316@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/17/2012 8:50 AM, David Brown wrote:
> ----- Forwarded message from Wei Yongjun <weiyj.lk@gmail.com> -----
>
> Date: Fri, 14 Sep 2012 10:28:31 +0800
> From: Wei Yongjun <weiyj.lk@gmail.com>
> To: grant.likely@secretlab.ca, linus.walleij@linaro.org
> Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
> Subject: [PATCH] gpio_msm: using for_each_set_bit to simplify the code
>
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Using for_each_set_bit() to simplify the code.
>
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>   drivers/gpio/gpio-msm-v2.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/gpio/gpio-msm-v2.c b/drivers/gpio/gpio-msm-v2.c
> index 5cb1227..38305be 100644
> --- a/drivers/gpio/gpio-msm-v2.c
> +++ b/drivers/gpio/gpio-msm-v2.c
> @@ -317,9 +317,7 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>   
>   	chained_irq_enter(chip, desc);
>   
> -	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
> -	     i < NR_GPIO_IRQS;
> -	     i = find_next_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS, i + 1)) {
> +	for_each_set_bit(i, msm_gpio.enabled_irqs, NR_GPIO_IRQS) {
>   		if (readl(GPIO_INTR_STATUS(i)) & BIT(INTR_STATUS))
>   			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
>   							   i));
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
> ----- End forwarded message -----
>
Tested-by: Rohit Vaswani <rvaswani@codeaurora.org>

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

