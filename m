Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2CJKvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 05:51:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:48660 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2CJKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 05:51:46 -0500
Date: Sat, 10 Mar 2012 11:51:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mike Turquette <mturquette@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v6 2/3] clk: introduce the common clock framework
In-Reply-To: <1331366064-1273-3-git-send-email-mturquette@linaro.org>
Message-ID: <alpine.LFD.2.02.1203101128100.2742@ionos>
References: <1331366064-1273-1-git-send-email-mturquette@linaro.org> <1331366064-1273-3-git-send-email-mturquette@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2012, Mike Turquette wrote:
> +inline unsigned long __clk_get_enable_count(struct clk *clk)
> +{
> +	return !clk ? -EINVAL : clk->enable_count;

Returning negative error codes in a function with a return value
unsigned long is a bit strange at least. Shouldn't that be long ?

> +#ifndef __LINUX_CLK_PRIVATE_H
> +#define __LINUX_CLK_PRIVATE_H
> +
> +#include <linux/clk-provider.h>
> +#include <linux/list.h>
> +
> +/*
> + * WARNING: Do not include clk-private.h from any file that implements struct
> + * clk_ops.  Doing so is a layering violation!
> + *
> + * This header exists only to allow for statically initialized clock data.  Any
> + * static clock data must be defined in a separate file from the logic that
> + * implements the clock operations for that same data.

Now the question is whether you should provide a data structure which
is explicitely used for static initialization and instead of having
struct clk static you register the static initializer structure, which
would be initdata. I don't think that anything needs clocks before the
memory allocators are up and running. The clocks which are necessary
to get that far have to be enabled in the boot loader anyway.

The static initialization question should not hold off this set from
being merged, though settling it before growing users would be nice.

Otherwise this is a very well done infrastructure implementation!
Thanks a lot Mike!

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
