Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab1JCWCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:02:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63567 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757678Ab1JCWCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:02:31 -0400
Message-ID: <4E8A30F2.7010502@gmail.com>
Date: Mon, 03 Oct 2011 17:02:26 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-kernel@vger.kernel.org, paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        broonie@opensource.wolfsonmicro.com, magnus.damm@gmail.com,
        amit.kucheria@linaro.org, richard.zhao@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
References: <1316730422-20027-1-git-send-email-mturquette@ti.com> <1316730422-20027-2-git-send-email-mturquette@ti.com>
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On 09/22/2011 05:26 PM, Mike Turquette wrote:

> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index 6db161f..e2a9719 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -23,6 +23,13 @@
>  static LIST_HEAD(clocks);
>  static DEFINE_MUTEX(clocks_mutex);
>  
> +/* For USE_COMMON_STRUCT_CLK, these are provided in clk.c, but not exported
> + * through other headers; we don't want them used anywhere but here. */
> +#ifdef CONFIG_USE_COMMON_STRUCT_CLK
> +extern int __clk_get(struct clk *clk);
> +extern void __clk_put(struct clk *clk);
> +#endif
> +

This is dead code left from prior versions.

Rob
