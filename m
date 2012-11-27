Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2K0SQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:16:15 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61064 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2K0SQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <1354028674-23685-3-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1354028674-23685-1-git-send-email-mark.langsdorf@calxeda.com> <1354028674-23685-3-git-send-email-mark.langsdorf@calxeda.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 27 Nov 2012 10:15:52 -0800
Message-ID: <CAPtuhTjjTTfXRAf6BAuG0L_NQubcYwCCi6WCBYR9ddtG-koMHw@mail.gmail.com>
Subject: Re: [PATCH 2/6 v5] clk, highbank: Prevent glitches in non-bypass
 reset mode
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 7:04 AM, Mark Langsdorf
<mark.langsdorf@calxeda.com> wrote:
>
> The highbank clock will glitch with the current code if the
> clock rate is reset without relocking the PLL. Program the PLL
> correctly to prevent glitches.
>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: mturquette@linaro.org

Acked-by: Mike Turquette <mturquette@linaro.org>

Regards,
Mike

> ---
> Changes from v4
>         None.
> Changes from v3
>         Changelog text and patch name now correspond to the actual patch.
>         was clk, highbank: remove non-bypass reset mode.
> Changes from v2
>         None.
> Changes from v1:
>         Removed erroneous reformating.
>
>  drivers/clk/clk-highbank.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
> index 52fecad..3a0b723 100644
> --- a/drivers/clk/clk-highbank.c
> +++ b/drivers/clk/clk-highbank.c
> @@ -182,8 +182,10 @@ static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
>                 reg |= HB_PLL_EXT_ENA;
>                 reg &= ~HB_PLL_EXT_BYPASS;
>         } else {
> +               writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
>                 reg &= ~HB_PLL_DIVQ_MASK;
>                 reg |= divq << HB_PLL_DIVQ_SHIFT;
> +               writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
>         }
>         writel(reg, hbclk->reg);
>
> --
> 1.7.11.7
>
