Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0KRKxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:53:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60091 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0KRKxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:53:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6170"; a="63365561"
Date: Thu, 18 Nov 2010 16:22:57 +0530
From: Pavan Kondeti <pkondeti@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: Re: [PATCH v3 1/2] msm: gpio: Add v2 gpio support to MSM SoCs.
Message-ID: <20101118105257.GC11700@codeaurora.org>
References: <1289943516-11367-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289943516-11367-1-git-send-email-gbean@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Nov 16, 2010 at 01:38:35PM -0800, Gregory Bean wrote:
> Beginning with the MSM8x60, the hardware block responsible for gpio
> support changes.  Provide gpiolib support for the new v2 architecture.
> 
> Cc: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> +static int __devinit msm_gpio_probe(struct platform_device *dev)
> +{
> +	int ret;
> +
> +	spin_lock_init(&tlmm_lock);

Not required. DEFINE_SPINLOCK() would have initialized the spinlock.
> +	msm_gpio.label = dev->name;
> +	ret = gpiochip_add(&msm_gpio);
> +
> +	return ret;
> +}
> +
> +static int __devexit msm_gpio_remove(struct platform_device *dev)
> +{
> +	int ret = gpiochip_remove(&msm_gpio);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	set_irq_handler(TLMM_SCSS_SUMMARY_IRQ, NULL);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver msm_gpio_driver = {
> +	.probe = msm_gpio_probe,
> +	.remove = __devexit_p(msm_gpio_remove),
> +	.driver = {
> +		.name = "msmgpio",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +static struct platform_device msm_device_gpio = {
> +	.name = "msmgpio",
> +	.id   = 0,
> +};
id = -1 right?
> +
> +static int __init msm_gpio_init(void)
> +{
> +	int rc;
> +
> +	rc = platform_driver_register(&msm_gpio_driver);
> +	if (rc == 0)
> +		rc = platform_device_register(&msm_device_gpio);

Should not we unregister the platform driver in case the above call returns
failure?
> +
> +	return rc;
> +}
> +
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

