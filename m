Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057Ab2DLGUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:20:44 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:42886 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396Ab2DLGUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:20:42 -0400
Message-ID: <4F8673C6.1010301@st.com>
Date: Thu, 12 Apr 2012 11:48:46 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
Cc: "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>, Rajendra Nayak <rnayak@ti.com>
Subject: Re: [PATCH 06/13] clk: remove unnecessary EXPORT_SYMBOL_GPL
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-7-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-7-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> It makes no sense to have EXPORT_SYMBOL_GPL on static functions.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/clk/clk-divider.c    |    3 ---
>  drivers/clk/clk-fixed-rate.c |    1 -
>  drivers/clk/clk-gate.c       |    3 ---
>  drivers/clk/clk-mux.c        |    2 --
>  4 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index d5ac6a7..231cd6e 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -45,7 +45,6 @@ static unsigned long clk_divider_recalc_rate(struct clk_hw *hw,
>  
>  	return parent_rate / div;
>  }
> -EXPORT_SYMBOL_GPL(clk_divider_recalc_rate);
>  
>  /*
>   * The reverse of DIV_ROUND_UP: The maximum number which
> @@ -117,7 +116,6 @@ static long clk_divider_round_rate(struct clk_hw *hw, unsigned long rate,
>  		return r / div;
>  	}
>  }
> -EXPORT_SYMBOL_GPL(clk_divider_round_rate);
>  
>  static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate)
>  {
> @@ -147,7 +145,6 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(clk_divider_set_rate);
>  
>  struct clk_ops clk_divider_ops = {
>  	.recalc_rate = clk_divider_recalc_rate,
> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index 90c79fb..651b06f 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -32,7 +32,6 @@ static unsigned long clk_fixed_rate_recalc_rate(struct clk_hw *hw,
>  {
>  	return to_clk_fixed_rate(hw)->fixed_rate;
>  }
> -EXPORT_SYMBOL_GPL(clk_fixed_rate_recalc_rate);
>  
>  struct clk_ops clk_fixed_rate_ops = {
>  	.recalc_rate = clk_fixed_rate_recalc_rate,
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> index b5902e2..b688f47 100644
> --- a/drivers/clk/clk-gate.c
> +++ b/drivers/clk/clk-gate.c
> @@ -71,7 +71,6 @@ static int clk_gate_enable(struct clk_hw *hw)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(clk_gate_enable);
>  
>  static void clk_gate_disable(struct clk_hw *hw)
>  {
> @@ -82,7 +81,6 @@ static void clk_gate_disable(struct clk_hw *hw)
>  	else
>  		clk_gate_clear_bit(gate);
>  }
> -EXPORT_SYMBOL_GPL(clk_gate_disable);
>  
>  static int clk_gate_is_enabled(struct clk_hw *hw)
>  {
> @@ -99,7 +97,6 @@ static int clk_gate_is_enabled(struct clk_hw *hw)
>  
>  	return reg ? 1 : 0;
>  }
> -EXPORT_SYMBOL_GPL(clk_gate_is_enabled);
>  
>  struct clk_ops clk_gate_ops = {
>  	.enable = clk_gate_enable,
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 50e0595..45cad61 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -55,7 +55,6 @@ static u8 clk_mux_get_parent(struct clk_hw *hw)
>  
>  	return val;
>  }
> -EXPORT_SYMBOL_GPL(clk_mux_get_parent);
>  
>  static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
>  {
> @@ -82,7 +81,6 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(clk_mux_set_parent);
>  
>  struct clk_ops clk_mux_ops = {
>  	.get_parent = clk_mux_get_parent,

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
