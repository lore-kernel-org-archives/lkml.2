Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233Ab2EDQ4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:56:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41510 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab2EDQ4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:56:49 -0400
Date: Fri, 4 May 2012 17:56:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rob Herring <robherring2@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, linaro-dev@lists.linaro.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@fluxnic.net>,
        Tony Lindgren <tony@atomide.com>, Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Message-ID: <20120504165603.GK897@n2100.arm.linux.org.uk>
References: <201205031350.35476.arnd@arndb.de> <20120503140428.GB897@n2100.arm.linux.org.uk> <201205041220.24747.arnd@arndb.de> <4FA40642.5040203@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA40642.5040203@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:39:30AM -0500, Rob Herring wrote:
> Many of the headers are simply platform_data structs which may still be
> needed on DT platforms, but could be moved elsewhere.

Those should be in include/linux/platform.

> >> Then there's also the problem of uncompress.h.  The last piece of the
> >> puzzle is the common clock stuff.
> 
> The smp/hotplug/localtimer related functions are still global. Marc Z
> has posted patches for this, but I haven't seen recent activity. This
> and clocks were the 2 main issues I saw trying to build 2 platforms
> together. highbank and picoxcell could be built together since only
> highbank has clocks and smp.
> 
> gpio.h is still required, but empty for most platforms.

Those empty gpio.h files are definitely a candidate for going into
arch/arm/include/mach/gpio.h, and then all those 12-byte mach/gpio.h can
be deleted (13 files).

We've not had any progress on the gpio.h issue since I did the last round
of cleanup; the next stage was to persuade SoC maintainers to get rid of
their optimized versions which aren't compatible with multi-platform
kernels.

I don't know if folk are expecting me to push that forwards or whether
there's someone else working on that aspect of it...

So this issue really does need to be progressed too.
