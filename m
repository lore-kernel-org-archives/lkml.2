Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2JMNCQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:02:16 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:9921 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab2JMNCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:02:14 -0400
Date: Sat, 13 Oct 2012 15:01:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: <w.sang@pengutronix.de>, <swarren@nvidia.com>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] i2c: tegra: set irq name as device name
Message-ID: <20121013150158.2eb1ece2@endymion.delvare>
In-Reply-To: <1350064172-32417-1-git-send-email-ldewangan@nvidia.com>
References: <1350064172-32417-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 23:19:32 +0530, Laxman Dewangan wrote:
> When watching the irqs name of tegra i2c, all instances
> irq name shows as tegra_i2c.
> 
> Passing the device name properly to have the irq names with
> instance like tegra-i2c.0, tegra-i2c.1 etc.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/i2c/busses/i2c-tegra.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index f981ac4..dcea77b 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -742,7 +742,7 @@ static int __devinit tegra_i2c_probe(struct platform_device *pdev)
>  	}
>  
>  	ret = devm_request_irq(&pdev->dev, i2c_dev->irq,
> -			tegra_i2c_isr, 0, pdev->name, i2c_dev);
> +			tegra_i2c_isr, 0, dev_name(&pdev->dev), i2c_dev);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
>  		return ret;

Good idea.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
