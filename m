Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1JWMpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:45:07 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:31954
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755441Ab1JWMpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:45:05 -0400
X-SpamScore: 4
X-BigFish: VS4(z1039oz98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Sun, 23 Oct 2011 20:55:56 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Mike Turquette <mturquette@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <jeremy.kerr@canonical.com>, <broonie@opensource.wolfsonmicro.com>,
        <tglx@linutronix.de>, <linus.walleij@stericsson.com>,
        <amit.kucheria@linaro.org>, <dsaxena@linaro.org>, <patches@linaro.org>,
        <linaro-dev@lists.linaro.org>, <paul@pwsan.com>,
        <grant.likely@secretlab.ca>, <sboyd@quiinc.com>, <skannan@quicinc.com>,
        <magnus.damm@gmail.com>, <arnd.bergmann@linaro.org>,
        <linux@arm.linux.org.uk>, <eric.miao@linaro.org>,
        <richard.zhao@linaro.org>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111023125555.GD1401@S2100-06.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316730422-20027-2-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Some random comments/nits ...

On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
> +struct clk *clk_register(const struct clk_hw_ops *ops, struct clk_hw *hw,
> +		const char *name)
> +{
> +	struct clk *clk;
> +
> +	clk = kzalloc(sizeof(*clk), GFP_KERNEL);
> +	if (!clk)
> +		return NULL;
> +
> +	INIT_HLIST_HEAD(&clk->children);
> +	INIT_HLIST_NODE(&clk->child_node);
> +
The children and child_node are introduced in patch #2, and should not
be used in patch #1.

> +	clk->name = name;
> +	clk->ops = ops;
> +	clk->hw = hw;
> +	hw->clk = clk;
> +
> +	/* Query the hardware for parent and initial rate */
> +
> +	if (clk->ops->get_parent)
> +		/* We don't to lock against prepare/enable here, as
> +		 * the clock is not yet accessible from anywhere */
/*
 * Multiple line comments
 */

> +		clk->parent = clk->ops->get_parent(clk->hw);
> +
> +	if (clk->ops->recalc_rate)
> +		clk->rate = clk->ops->recalc_rate(clk->hw);
> +
> +
One blank line is good enough.

> +	return clk;
> +}

-- 
Regards,
Shawn

