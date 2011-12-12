Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab1LLViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:38:46 -0500
Received: from londo.lunn.ch ([80.238.139.98]:54825 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415Ab1LLVio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:38:44 -0500
Date: Mon, 12 Dec 2011 22:38:26 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, aul@pwsan.com, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org
Subject: Re: [PATCH v3 4/5] clk: basic gateable and fixed-rate clks
Message-ID: <20111212213826.GH13600@lunn.ch>
References: <20111212194757.GB12131@lunn.ch>
 <CAJOA=zP1CAsCqJERvXC6tTh_gs_boGYnO3MUC5=Vgiiw=0Vs_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJOA=zP1CAsCqJERvXC6tTh_gs_boGYnO3MUC5=Vgiiw=0Vs_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't like this approach.  If the bool for a particular clk is
> statically defined then it could be wrong (bootloader/kernel
> mismatch).
> 
> I've been thinking of adding a clk->ops->init callback in clk_init,
> which is defined for a platform to use however the author sees fit.
> There have been a few cases where it would be nice to "init" a clk
> only once, when it is registered.  That code could also handle
> detecting if a clk is enabled or not.
> 
> On the other hand we already have a .get_parent callback which is only
> good for figuring out which parent a mux clk is using... maybe a
> .is_enabled or .get_enabled would be a good idea which also served the
> purpose of dynamically determining whether a clk is disabled or
> running.
> 
> In general though I think we should try to keep the solution in the
> core code, not by having platform code pass in a bool.

Hi Mike

How about simply reading the bit in the control register? You are
already doing a read/modify/write when enabling/disabling the clock,
so it seems reasonably safe to assume the read gives you the current
state. For those platforms which this does not work, you could add
another flag disabling this read to get the initial state.

	Andrew
