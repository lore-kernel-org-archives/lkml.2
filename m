Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1JQJUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:20:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab1JQJUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:20:31 -0400
Date: Mon, 17 Oct 2011 10:20:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, paul@pwsan.com,
        linaro-dev@lists.linaro.org, linus.walleij@stericsson.com,
        patches@linaro.org, magnus.damm@gmail.com,
        linux-kernel@vger.kernel.org, eric.miao@linaro.org,
        grant.likely@secretlab.ca, arnd.bergmann@linaro.org,
        dsaxena@linaro.org, tglx@linutronix.de, amit.kucheria@linaro.org,
        linux@arm.linux.org.uk, skannan@quicinc.com,
        Mike Turquette <mturquette@ti.com>, jeremy.kerr@canonical.com,
        shawn.guo@freescale.com, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111017092028.GA3042@opensource.wolfsonmicro.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <20111014081024.GA9485@b20223-02.ap.freescale.net>
 <20111014100504.GC2966@opensource.wolfsonmicro.com>
 <20111014103233.GB9485@b20223-02.ap.freescale.net>
 <20111016175521.GA13565@pengutronix.de>
 <20111017084851.GB20184@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017084851.GB20184@b20223-02.ap.freescale.net>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 04:48:52PM +0800, Richard Zhao wrote:

> For example, devices that possible access to on-chip RAM, depend on OCRAM clock. 
> On imx53, VPU depends on OCRAM clock, even when VPU does not use OCRAM.

So if the VPU depends on OCRAM the VPU should be enabling the OCRAM
clock.  The function of a given clock isn't terribly relevant, and
certainly grouping clocks together doesn't seem to be the obvious
solution from what you've said - if the driver doesn't know about the
clock it seems like the core ought to be enabling it transparently
rather than gluing it together with some other random clock.

Either way the point here is that individual drivers shouldn't be hand
coding this stuff, it should be being handled by core code.
