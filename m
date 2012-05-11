Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab2EKRkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:40:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48272 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab2EKRkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:40:15 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] gpio: tps65910: move this as platform driver
To: Laxman Dewangan <ldewangan@nvidia.com>, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1336569057-3890-5-git-send-email-ldewangan@nvidia.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com> <1336569057-3890-5-git-send-email-ldewangan@nvidia.com>
Date: Fri, 11 May 2012 11:40:11 -0600
Message-Id: <20120511174011.3160B3E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 May 2012 18:40:57 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Make the gpio-tps65910 as platform driver and register
> this from tps65910 core driver as mfd sub device.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Minor comment below, but otherwise:

Acked-by: Grant Likely <grant.likely@secretlab.ca>
> +static struct platform_driver tps65910_gpio_driver = {
> +	.driver.name    = "tps65910-gpio",
> +	.driver.owner   = THIS_MODULE,
> +	.probe		= tps65910_gpio_probe,
> +	.remove		= __devexit_p(tps65910_gpio_remove),
> +};
> +
> +static int __init tps65910_gpio_init(void)
> +{
> +	return platform_driver_register(&tps65910_gpio_driver);
> +}
> +subsys_initcall(tps65910_gpio_init);
> +
> +static void __exit tps65910_gpio_exit(void)
> +{
> +	platform_driver_unregister(&tps65910_gpio_driver);
> +}
> +module_exit(tps65910_gpio_exit);

module_platform_driver()

