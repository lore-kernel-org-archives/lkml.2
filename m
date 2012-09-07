Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261Ab2IGV1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:27:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35052 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab2IGV1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:27:37 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Murali Karicheri <m-karicheri2@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1346351350-28807-1-git-send-email-m-karicheri2@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>
References: <1346351350-28807-1-git-send-email-m-karicheri2@ti.com>
Message-ID: <20120907212732.20289.62310@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] wdt:clk: preparation for switch to common clock framework
Date: Fri, 07 Sep 2012 14:27:32 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Murali Karicheri (2012-08-30 11:29:10)
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
>  drivers/watchdog/davinci_wdt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index c8c5c80..eb44b03 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -208,7 +208,7 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
>         if (WARN_ON(IS_ERR(wdt_clk)))
>                 return PTR_ERR(wdt_clk);
>  
> -       clk_enable(wdt_clk);
> +       clk_prepare_enable(wdt_clk);
>  
>         if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
>                 heartbeat = DEFAULT_HEARTBEAT;
> @@ -256,7 +256,7 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
>                 wdt_mem = NULL;
>         }
>  
> -       clk_disable(wdt_clk);
> +       clk_disable_unprepare(wdt_clk);
>         clk_put(wdt_clk);
>  
>         return 0;
> -- 
> 1.7.9.5
