Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab2DLGV7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:21:59 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:34949 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757085Ab2DLGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:21:58 -0400
Message-ID: <4F867416.1040603@st.com>
Date: Thu, 12 Apr 2012 11:50:06 +0530
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
Subject: Re: [PATCH 08/13] clk: declare clk_ops of basic clks in clk-provider.h
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-9-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-9-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> Besides the static initialization, the clk_ops of basic clks could
> also be used by particular clk type being subclass of the basic clks.
> 
> For example, clk_busy_divider has the same clk_ops as clk_divider,
> except it has to wait for a busy bit before return success with
> .set_rate.  clk_busy_divider will somehow reuse clk_ops of clk_divider.
> 
> Since clk-provider.h is included by clk-private.h, it's safe to move
> those clk_ops declaration of basic clks form  clk-private.h into
> clk-provider.h, so that implementation of clks like clk_busy_divider
> above do not need to include clk-private.h to access those clk_ops.
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
>  include/linux/clk-private.h  |    8 --------
>  include/linux/clk-provider.h |    4 ++++
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 5f4ccd7..f19fee0 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -55,8 +55,6 @@ struct clk {
>   * alternative macro for static initialization
>   */
>  
> -extern const struct clk_ops clk_fixed_rate_ops;
> -
>  #define DEFINE_CLK_FIXED_RATE(_name, _flags, _rate,		\
>  				_fixed_rate_flags)		\
>  	static struct clk _name;				\
> @@ -78,8 +76,6 @@ extern const struct clk_ops clk_fixed_rate_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern const struct clk_ops clk_gate_ops;
> -
>  #define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,	\
>  				_flags, _reg, _bit_idx,		\
>  				_gate_flags, _lock)		\
> @@ -110,8 +106,6 @@ extern const struct clk_ops clk_gate_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern const struct clk_ops clk_divider_ops;
> -
>  #define DEFINE_CLK_DIVIDER(_name, _parent_name, _parent_ptr,	\
>  				_flags, _reg, _shift, _width,	\
>  				_divider_flags, _lock)		\
> @@ -143,8 +137,6 @@ extern const struct clk_ops clk_divider_ops;
>  		.flags = _flags,				\
>  	};
>  
> -extern const struct clk_ops clk_mux_ops;
> -
>  #define DEFINE_CLK_MUX(_name, _parent_names, _parents, _flags,	\
>  				_reg, _shift, _width,		\
>  				_mux_flags, _lock)		\
> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> index 5508897..6eb8e5d 100644
> --- a/include/linux/clk-provider.h
> +++ b/include/linux/clk-provider.h
> @@ -149,6 +149,7 @@ struct clk_fixed_rate {
>  	u8		flags;
>  };
>  
> +extern const struct clk_ops clk_fixed_rate_ops;
>  struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
>  		unsigned long fixed_rate);
> @@ -180,6 +181,7 @@ struct clk_gate {
>  
>  #define CLK_GATE_SET_TO_DISABLE		BIT(0)
>  
> +extern const struct clk_ops clk_gate_ops;
>  struct clk *clk_register_gate(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
>  		void __iomem *reg, u8 bit_idx,
> @@ -218,6 +220,7 @@ struct clk_divider {
>  #define CLK_DIVIDER_ONE_BASED		BIT(0)
>  #define CLK_DIVIDER_POWER_OF_TWO	BIT(1)
>  
> +extern const struct clk_ops clk_divider_ops;
>  struct clk *clk_register_divider(struct device *dev, const char *name,
>  		const char *parent_name, unsigned long flags,
>  		void __iomem *reg, u8 shift, u8 width,
> @@ -252,6 +255,7 @@ struct clk_mux {
>  #define CLK_MUX_INDEX_ONE		BIT(0)
>  #define CLK_MUX_INDEX_BIT		BIT(1)
>  
> +extern const struct clk_ops clk_mux_ops;
>  struct clk *clk_register_mux(struct device *dev, const char *name,
>  		char **parent_names, u8 num_parents, unsigned long flags,
>  		void __iomem *reg, u8 shift, u8 width,

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
