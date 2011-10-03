Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab1JCQbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:31:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36366 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753351Ab1JCQbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:31:14 -0400
Date: Mon, 3 Oct 2011 17:31:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        magnus.damm@gmail.com, amit.kucheria@linaro.org,
        richard.zhao@linaro.org, grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111003163107.GQ3731@opensource.wolfsonmicro.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <4E89C3FA.9020206@gmail.com>
 <20111003142524.GN3731@opensource.wolfsonmicro.com>
 <4E89D3C4.8090001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E89D3C4.8090001@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 10:24:52AM -0500, Rob Herring wrote:
> On 10/03/2011 09:25 AM, Mark Brown wrote:

> > This isn't in any way specific to clocks, right now the likely solution
> > looks to be Grant's changes for retrying probe() as new devices come on
> > line.  With that devices can return a code from their probe() which
> > tells the driver core that they couldn't get all the resources they need
> > and that it should retry the probe() if more devices come on-line.

> Except SOC clocks are initialized very early before timers are up and
> there can be a very high number of dependencies (every clock except
> fixed clocks). With the driver probe retry, retrying is the exception,
> not the rule.

> Retrying would require every caller to maintain a list of clks to
> retry. With 2 stages, you can move that into the core clock code.

They don't need to maintain a list of clocks to retry, they need to
unwind when probe() fails.  But yes.

> There are not typically a large number of board-level/driver created
> clocks, so ensuring correct register order is not really a problem. In
> cases where there is a cross-driver dependency, the probe retry is a
> good solution.

I dunno, I get the impression that some of this is due to the current
limitations of the clock API rather than due to a lack of clocks -
perhaps that's specific to the applications I look at, though.
applications 
