Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab1JWOOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:14:53 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:54304
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab1JWOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:14:52 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz154dM1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Sun, 23 Oct 2011 22:24:59 +0800
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
Subject: Re: [PATCH v2 2/7] clk: Implement clk_set_rate
Message-ID: <20111023142458.GE1401@S2100-06.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-3-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316730422-20027-3-git-send-email-mturquette@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 03:26:57PM -0700, Mike Turquette wrote:
> From: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> Implement clk_set_rate by adding a set_rate callback to clk_hw_ops.
> Rates are propagated down the clock tree and recalculated.  Also adds a
> flag for signaling that parents must change rates to achieve the desired
> frequency (upstream propagation).
> 
> TODO:
> Upstream propagation is not yet implemented.
> Device pre-change and post-change notifications are not implemented, but
> are marked up as FIXME comments.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Mike Turquette <mturquette@ti.com>
> ---
> Changes since v1:
> Remove upstream propagation (for now)
> Rename CLK_SET_RATE_PROPAGATE to CLK_PARENT_RATE_CHANGE

[...]

> + * @set_rate	Change the rate of this clock. If this callback returns
> + *		CLK_SET_RATE_PROPAGATE, the rate change will be propagated to

s/CLK_SET_RATE_PROPAGATE/CLK_PARENT_RATE_CHANGE, as suggested by your
change log above?

> + *		the parent clock (which may propagate again). The requested
> + *		rate of the parent is passed back from the callback in the
> + *		second 'unsigned long *' argument.
> + *

-- 
Regards,
Shawn

