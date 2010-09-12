Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab0ILIC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 04:02:59 -0400
Received: from compulab.co.il ([67.18.134.219]:47248 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab0ILICx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 04:02:53 -0400
Message-ID: <4C8C88DD.5070406@compulab.co.il>
Date: Sun, 12 Sep 2010 10:01:33 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Gary King <gking@nvidia.com>
CC: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v2] mfd: tps6586x: add basic interrupt support
References: <1283890548-29442-1-git-send-email-gking@nvidia.com>
In-Reply-To: <1283890548-29442-1-git-send-email-gking@nvidia.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gary,

Gary King wrote:
> Hi Samuel, Mike,
> 
> This patch incorporates Mike Rapoport's feedback on my initial patch
> to add interrupt support to the tps6586x driver.

Overall looks good to me, two nitpicking comments though.

> Changes since v1:
> 
> * Move the interrupt enum ordering to match the ACK register values
> 
> * Treat the INT_ACK registers as a single 32b unsigned int.
> 
> * Name and define all the interrupts on the device
> 
> * If reading the ACK registers in the interrupt thread fails, IRQ_NONE
>   is returned, rather than disabling the IRQ handler. This fixes
>   interrupts following suspend.
> 
> * The cascaded IRQ is passed through the i2c_client's .irq field, rather
>   than through platform data.
> 
> --
> From bf2f95da6f192e091d9ac0b30c186050aa5fd4e5 Mon Sep 17 00:00:00 2001
> From: Gary King <gking@nvidia.com>
> Date: Mon, 30 Aug 2010 16:16:55 -0700
> Subject: mfd: tps6586x: add basic interrupt support
> 
> add support for enabling and disabling tps6586x subdevice interrupts,
> and add support for the RTC interrupts

I think the "add support for the RTC interrupts" is not relevant anymore

> Signed-off-by: Gary King <gking@nvidia.com>
> ---
>  drivers/mfd/tps6586x.c       |  202 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps6586x.h |   31 +++++++
>  2 files changed, 233 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 4cde31e..626081c 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -15,6 +15,8 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/mutex.h>

[ snip ]

>  struct tps6586x_subdev_info {
>  	int		id;
>  	const char	*name;
> @@ -29,6 +59,7 @@ struct tps6586x_platform_data {
>  	struct tps6586x_subdev_info *subdevs;
>  
>  	int gpio_base;
> +	int irq_base;

not needed anymore

>  };
>  
>  /*


-- 
Sincerely yours,
Mike.
