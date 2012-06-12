Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2FLXGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 19:06:38 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52281 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847Ab2FLXGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 19:06:37 -0400
Date: Tue, 12 Jun 2012 16:06:30 -0700
From: Mike Turquette <mturquette@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/3] clk: add ICST307 driver
Message-ID: <20120612230630.GK19410@gmail.com>
References: <1339429196-32584-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339429196-32584-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20120611-17:39, Linus Walleij wrote:
> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> index b9a5158..a7a7cf8 100644
> --- a/drivers/clk/Makefile
> +++ b/drivers/clk/Makefile
> @@ -5,3 +5,4 @@ obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
>  # SoCs specific
>  obj-$(CONFIG_ARCH_MXS)		+= mxs/
>  obj-$(CONFIG_PLAT_SPEAR)	+= spear/
> +obj-$(CONFIG_CLK_ICST)		+= clk-icst.o

Is there a better place to put this than the top-level directory?

> +struct clk * __init icst_clk_init(struct device *dev, const struct clk_icst_desc *desc)

Nitpick: icst_clk_init should be renamed icst_clk_register to more
closely resemble other clock registration functions which allocate
memory dynamically.

So far the "_init" suffix has been used by functions which operate on
statically initialized data.

Regards,
Mike
