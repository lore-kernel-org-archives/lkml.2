Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2DLGVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:21:21 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:36639 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab2DLGVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:21:19 -0400
Message-ID: <4F8673EB.6000504@st.com>
Date: Thu, 12 Apr 2012 11:49:23 +0530
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
Subject: Re: [PATCH 07/13] clk: add "const" for clk_ops of basic clks
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-8-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-8-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> The clk_ops of basic clks should have "const" to match the definition
> in "struct clk" and clk_register prototype.
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
>  drivers/clk/clk-divider.c    |    2 +-
>  drivers/clk/clk-fixed-rate.c |    2 +-
>  drivers/clk/clk-gate.c       |    2 +-
>  drivers/clk/clk-mux.c        |    2 +-
>  include/linux/clk-private.h  |    8 ++++----
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> index 231cd6e..b1c4b02 100644
> --- a/drivers/clk/clk-divider.c
> +++ b/drivers/clk/clk-divider.c
> @@ -146,7 +146,7 @@ static int clk_divider_set_rate(struct clk_hw *hw, unsigned long rate)
>  	return 0;
>  }
>  
> -struct clk_ops clk_divider_ops = {
> +const struct clk_ops clk_divider_ops = {
>  	.recalc_rate = clk_divider_recalc_rate,
>  	.round_rate = clk_divider_round_rate,
>  	.set_rate = clk_divider_set_rate,
> diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
> index 651b06f..027e477 100644
> --- a/drivers/clk/clk-fixed-rate.c
> +++ b/drivers/clk/clk-fixed-rate.c
> @@ -33,7 +33,7 @@ static unsigned long clk_fixed_rate_recalc_rate(struct clk_hw *hw,
>  	return to_clk_fixed_rate(hw)->fixed_rate;
>  }
>  
> -struct clk_ops clk_fixed_rate_ops = {
> +const struct clk_ops clk_fixed_rate_ops = {
>  	.recalc_rate = clk_fixed_rate_recalc_rate,
>  };
>  EXPORT_SYMBOL_GPL(clk_fixed_rate_ops);
> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
> index b688f47..fe2ff9e 100644
> --- a/drivers/clk/clk-gate.c
> +++ b/drivers/clk/clk-gate.c
> @@ -98,7 +98,7 @@ static int clk_gate_is_enabled(struct clk_hw *hw)
>  	return reg ? 1 : 0;
>  }
>  
> -struct clk_ops clk_gate_ops = {
> +const struct clk_ops clk_gate_ops = {
>  	.enable = clk_gate_enable,
>  	.disable = clk_gate_disable,
>  	.is_enabled = clk_gate_is_enabled,
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index 45cad61..5424488 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -82,7 +82,7 @@ static int clk_mux_set_parent(struct clk_hw *hw, u8 index)
>  	return 0;
>  }
>  
> -struct clk_ops clk_mux_ops = {
> +const struct clk_ops clk_mux_ops = {
>  	.get_parent = clk_mux_get_parent,
>  	.set_parent = clk_mux_set_parent,
>  };
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 5e4312b..5f4ccd7 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -55,7 +55,7 @@ struct clk {
>   * alternative macro for static initialization
>   */
>  
> -extern struct clk_ops clk_fixed_rate_ops;
> +extern const struct clk_ops clk_fixed_rate_ops;
>  
>  #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
>  				_fixed_rate_flags)		\
> @@ -78,7 +78,7 @@ extern struct clk_ops clk_fixed_rate_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern struct clk_ops clk_gate_ops;
> +extern const struct clk_ops clk_gate_ops;
>  
>  #define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
>  				_flags, _reg, _bit_idx,		\
> @@ -110,7 +110,7 @@ extern struct clk_ops clk_gate_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern struct clk_ops clk_divider_ops;
> +extern const struct clk_ops clk_divider_ops;
>  
>  #define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
>  				_flags, _reg, _shift, _width,	\
> @@ -143,7 +143,7 @@ extern struct clk_ops clk_divider_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern struct clk_ops clk_mux_ops;
> +extern const struct clk_ops clk_mux_ops;
>  
>  #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
>  				_reg, _shift, _width,		\

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
