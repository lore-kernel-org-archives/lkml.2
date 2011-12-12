Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1LLUIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:08:05 -0500
Received: from londo.lunn.ch ([80.238.139.98]:53059 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739Ab1LLUID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:08:03 -0500
X-Greylist: delayed 1195 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Dec 2011 15:08:03 EST
Date: Mon, 12 Dec 2011 20:47:57 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: mturquette@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        aul@pwsan.com, grant.likely@secretlab.ca, sboyd@quicinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@ti.com
Subject: Re: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Message-ID: <20111212194757.GB12131@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike

+int clk_register_gate(struct device *dev, const char *name, unsigned long flags,
+ 			      struct clk *fixed_parent, void __iomem *reg, u8 bit_idx,
+			      	     int set_to_enable)
+

How do you suggest handling gated clocks which are already running
when calling the register function?

On my kirkwood bases system, the bootloader has already turned on a
number of clocks. It does not seem right to start messing with
clk->enable_count and clk->prepare_count. Could clk_register_gate()
have one more parameter, a bool indicating running?

The kirkwood mach code keeps a bitmap of which platform_data init
functions are called from the board file. In a late_initcall function
it then enables and disables clocks as needed. What i was thinking is
i can ask the hardware what clocks are already running before i
register them and register them as running/not running. Then let the
driver probe functions use the API to enable clocks which are really
needed. In a late_initcall function, i would then call clk_disable(),
clk_unprepare() on clocks which the boot loader started, thus turning
them off if no driver has claimed them.

Is this how you envisage it working?

Thanks
	Andrew
