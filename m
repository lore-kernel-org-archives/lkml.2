Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2CRNpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 09:45:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34272 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab2CRNpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 09:45:52 -0400
Date: Sun, 18 Mar 2012 21:46:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
Message-ID: <20120318134623.GB29638@S2101-09.ap.freescale.net>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org>
 <1331878280-2758-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331878280-2758-3-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the documentation of function clk_set_rate(), I'm not sure
it exactly matches what the code does.

If there is mismatch, it might be worth sending an incremental patch
to update the documentation and avoid the confusion?

On Thu, Mar 15, 2012 at 11:11:19PM -0700, Mike Turquette wrote:
> +/**
> + * clk_set_rate - specify a new rate for clk
> + * @clk: the clk whose rate is being changed
> + * @rate: the new rate for clk
> + *
> + * In the simplest case clk_set_rate will only change the rate of clk.
> + *
> + * If clk has the CLK_SET_RATE_GATE flag set and it is enabled this call
> + * will fail; only when the clk is disabled will it be able to change
> + * its rate.
> + *
> + * Setting the CLK_SET_RATE_PARENT flag allows clk_set_rate to
> + * recursively propagate up to clk's parent; whether or not this happens
> + * depends on the outcome of clk's .round_rate implementation.  If
> + * *parent_rate is 0 after calling .round_rate then upstream parent

Might "*parent_rate is not changed" be more accurate?

> + * propagation is ignored.  If *parent_rate comes back with a new rate
> + * for clk's parent then we propagate up to clk's parent and set it's
> + * rate.  Upward propagation will continue until either a clk does not
> + * support the CLK_SET_RATE_PARENT flag or .round_rate stops requesting
> + * changes to clk's parent_rate.

> + * If there is a failure during upstream
> + * propagation then clk_set_rate will unwind and restore each clk's rate
> + * that had been successfully changed.  Afterwards a rate change abort
> + * notification will be propagated downstream, starting from the clk
> + * that failed.

I'm not sure this part still matches the code.

> + *
> + * At the end of all of the rate setting, clk_set_rate internally calls
> + * __clk_recalc_rates and propagates the rate changes downstream,

I do not see __clk_recalc_rates is called by clk_set_rate in any way.

Regards,
Shawn

> + * starting from the highest clk whose rate was changed.  This has the
> + * added benefit of propagating post-rate change notifiers.
> + *
> + * Note that while post-rate change and rate change abort notifications
> + * are guaranteed to be sent to a clk only once per call to
> + * clk_set_rate, pre-change notifications will be sent for every clk
> + * whose rate is changed.  Stacking pre-change notifications is noisy
> + * for the drivers subscribed to them, but this allows drivers to react
> + * to intermediate clk rate changes up until the point where the final
> + * rate is achieved at the end of upstream propagation.
> + *
> + * Returns 0 on success, -EERROR otherwise.
> + */
