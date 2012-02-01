Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2BAQYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:24:12 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:47674 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927Ab2BAQYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:24:11 -0500
Message-ID: <4F296721.5040203@stericsson.com>
Date: Wed, 1 Feb 2012 17:24:01 +0100
From: Maxime Coquelin <maxime.coquelin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111110 Thunderbird/8.0
MIME-Version: 1.0
To: Linus WALLEIJ <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alex MACRO <alex.macro@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>
Subject: Re: [PATCH 1/4] mfd/ab8500: fix error path bug
References: <1328112555-32459-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1328112555-32459-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 02/01/2012 05:09 PM, Linus WALLEIJ wrote:
> From: Linus Walleij<linus.walleij@linaro.org>
>
> We were not freeing the irq properly in the error path in
> the AB8500 driver.
>
> Cc: Mark Brown<broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Maxime Coquelin<maxime.coquelin@stericsson.com>
> Signed-off-by: Alex Macro<alex.macro@stericsson.com>
> Signed-off-by: Michel Jaouen<michel.jaouen@stericsson.com>
> Signed-off-by: Linus Walleij<linus.walleij@linaro.org>
> ---
>   drivers/mfd/ab8500-core.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index 53e2a80..bf823d2 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -956,9 +956,10 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
>   	return ret;
>
>   out_freeirq:
> -	if (ab8500->irq_base) {
> +	if (ab8500->irq_base)
>   		free_irq(ab8500->irq, ab8500);
>   out_removeirq:
> +	if (ab8500->irq_base)
>   		ab8500_irq_remove(ab8500);
>   	}
Shouldn't the above brace to be removed?
>   	return ret;

Regards,
Maxime
