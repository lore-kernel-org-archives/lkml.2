Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab2FUH1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:27:21 -0400
Received: from void.printf.net ([89.145.121.20]:54596 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab2FUH1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:27:19 -0400
From: Chris Ball <cjb@laptop.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, mturquette@linaro.org,
        s.hauer@pengutronix.de, sboyd@codeaurora.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, skannan@codeaurora.org,
        shawn.guo@linaro.org, Mitch Bradley <wmb@laptop.org>
Subject: Re: [PATCH v3 0/4] DT clock bindings
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
Date: Thu, 21 Jun 2012 03:27:00 -0400
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com> (Rob
	Herring's message of "Tue, 12 Jun 2012 09:41:47 -0500")
Message-ID: <87bokd15x7.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Tue, Jun 12 2012, Rob Herring wrote:
> This series defines clock bindings for Device-Tree and adds kernel
> support using the common clock infrastructure. The last patch enables
> DT clock support for the Calxeda Highbank platform.
>
> I'm posting this again to solicit further review. There has been some
> discussion[1], but no definite path forward. This series is not changed
> from the last post other than rebasing to v3.5-rc2.

This is a very useful patchset, thanks!  Mitch Bradley and I have been
hooking up the mach-mmp ARM subarchitecture to it and we needed to
make a few changes, mainly because mach-mmp doesn't use COMMON_CLK.
The changes are:

1) Remove the COMMON_CLK dependency that the of_clk_* functions have by
   moving them into a new file, drivers/clk/clk-of.c.  The OF functions
   in drivers/clk/clk.c aren't dependent on anything else in clk.c
   (since you pass them a struct clk) so they can be moved out easily.
   The of_clk_* entries in clk-provider.h move to clk.h.

2) Use alloc_bootmem() instead of kzalloc() in of_clk_add_provider(),
   because we need to set up clocks during .init_early on ARM (which
   happens pre-slab) so that they are available for platform init.

I'll send our patches in a reply to this mail.  Are you okay with these
changes, and would you like to include them in your patchset?

Thanks very much,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
