Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2DLGT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 02:19:57 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:53536 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396Ab2DLGTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 02:19:55 -0400
Message-ID: <4F86739E.8080300@st.com>
Date: Thu, 12 Apr 2012 11:48:06 +0530
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
Subject: Re: [PATCH 05/13] clk: use kzalloc in clk_register_mux
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org> <1334192572-12499-6-git-send-email-mturquette@linaro.org>
In-Reply-To: <1334192572-12499-6-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 6:32 AM, Mike Turquette wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> Change clk_register_mux to use kzalloc, just like what all other basic
> clk registration functions do.
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
>  drivers/clk/clk-mux.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> index c71ad1f..50e0595 100644
> --- a/drivers/clk/clk-mux.c
> +++ b/drivers/clk/clk-mux.c
> @@ -97,7 +97,7 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>  {
>  	struct clk_mux *mux;
>  
> -	mux = kmalloc(sizeof(struct clk_mux), GFP_KERNEL);
> +	mux = kzalloc(sizeof(struct clk_mux), GFP_KERNEL);
>  
>  	if (!mux) {
>  		pr_err("%s: could not allocate mux clk\n", __func__);

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
