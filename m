Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2DLGXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:23:08 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:59815 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753292Ab2DLGXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:23:06 -0400
Message-ID: <4F867459.20806@st.com>
Date: Thu, 12 Apr 2012 11:51:13 +0530
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
        Rajendra Nayak <rnayak@ti.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 09/13] clk: Make clk_get_rate() return 0 on error
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-10-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-10-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> From: Rajendra Nayak <rnayak@ti.com>
> 
> Most users of clk_get_rate() actually assume a non zero
> return value as a valid rate returned. Returing -EINVAL
> might confuse such users, so make it instead return zero
> on error.
> 
> Besides the return value of clk_get_rate seems to be
> 'unsigned long'.
> 
> Signed-off-by: Rajendra nayak <rnayak@ti.com>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> Cc: Arnd Bergman <arnd.bergmann@linaro.org>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Richard Zhao <richard.zhao@linaro.org>
> Cc: Saravana Kannan <skannan@codeaurora.org>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/clk/clk.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 9924aec..a24b121 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -285,7 +285,7 @@ unsigned long __clk_get_rate(struct clk *clk)
>  	unsigned long ret;
>  
>  	if (!clk) {
> -		ret = -EINVAL;
> +		ret = 0;
>  		goto out;
>  	}
>  
> @@ -295,7 +295,7 @@ unsigned long __clk_get_rate(struct clk *clk)
>  		goto out;
>  
>  	if (!clk->parent)
> -		ret = -ENODEV;
> +		ret = 0;
>  
>  out:
>  	return ret;
> @@ -560,7 +560,7 @@ EXPORT_SYMBOL_GPL(clk_enable);
>   * @clk: the clk whose rate is being returned
>   *
>   * Simply returns the cached rate of the clk.  Does not query the hardware.  If
> - * clk is NULL then returns -EINVAL.
> + * clk is NULL then returns 0.
>   */
>  unsigned long clk_get_rate(struct clk *clk)
>  {

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
