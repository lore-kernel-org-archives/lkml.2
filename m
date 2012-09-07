Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2IGV3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:29:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507Ab2IGV3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:29:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Murali Karicheri <m-karicheri2@ti.com>, <dwmw2@infradead.org>,
        <artem.bityutskiy@linux.intel.com>, <dbaryshkov@gmail.com>,
        <computersforpeace@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>
References: <1346350624-27291-1-git-send-email-m-karicheri2@ti.com>
Message-ID: <20120907212853.20289.86031@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] mtd:nand:clk: preparation for switch to common clock framework
Date: Fri, 07 Sep 2012 14:28:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Murali Karicheri (2012-08-30 11:17:04)
> As a first step towards migrating davinci platforms to use common clock
> framework, replace all instances of clk_enable() with clk_prepare_enable()
> and clk_disable() with clk_disable_unprepare(). Until the platform is
> switched to use the CONFIG_HAVE_CLK_PREPARE Kconfig variable, this just
> adds a might_sleep() call and would work without any issues.
> 
> This will make it easy later to switch to common clk based implementation
> of clk driver from DaVinci specific driver.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/mtd/nand/davinci_nand.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index d94b03c..6b8cf27 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -656,7 +656,7 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>                 goto err_clk;
>         }
>  
> -       ret = clk_enable(info->clk);
> +       ret = clk_prepare_enable(info->clk);
>         if (ret < 0) {
>                 dev_dbg(&pdev->dev, "unable to enable AEMIF clock, err %d\n",
>                         ret);
> @@ -767,7 +767,7 @@ syndrome_done:
>  
>  err_scan:
>  err_timing:
> -       clk_disable(info->clk);
> +       clk_disable_unprepare(info->clk);
>  
>  err_clk_enable:
>         clk_put(info->clk);
> @@ -804,7 +804,7 @@ static int __exit nand_davinci_remove(struct platform_device *pdev)
>  
>         nand_release(&info->mtd);
>  
> -       clk_disable(info->clk);
> +       clk_disable_unprepare(info->clk);
>         clk_put(info->clk);
>  
>         kfree(info);
> -- 
> 1.7.9.5
