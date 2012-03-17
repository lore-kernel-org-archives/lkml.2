Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2CQVNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 17:13:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64229 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab2CQVNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 17:13:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Sat, 17 Mar 2012 21:13:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "Turquette, Mike" <mturquette@ti.com>, Paul Walmsley <paul@pwsan.com>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAJOA=zNVSWR6xZEfx4hioB-Q7M6PsrP9gdvJc1t+YN=QVE=83w@mail.gmail.com> <20120317202931.GN3852@pengutronix.de>
In-Reply-To: <20120317202931.GN3852@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203172113.31122.arnd@arndb.de>
X-Provags-ID: V02:K0:yj8CmfOXLDNAPh9N0fD/c18HP8ZiOsgbNqn9o9hbMxE
 cLzXhyHi+HXUGO0nIMa0DI2Qh+0TLxxliKlWNXJBFmUa6tj2VK
 plloAI3Jo4uderrUAv1wkbdz2xbPZUXclhHuffEfm9hAbudSHh
 8S3mtdMWHLp0HtiMt7tw3ppIUtBlFR7T6E+a5Xpu09UGq9rCzT
 G7B2NHx7HANXhh+OlZHe1T8wGDuLlbwXssQ/t+fcfsVQ95rUWr
 3t9Ght78lPtpXZnMZj3CYKqhIZrBO4Lz+26thAuLD15JTNWfK8
 4nQGGdndl4Djrl0bWF3LzpkMiJo0Q4w9UkfupArcXt2NRscwBe
 UQPgRpsqxWWFiCM6kAjA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2012, Sascha Hauer wrote:
> On Sat, Mar 17, 2012 at 11:02:11AM -0700, Turquette, Mike wrote:
> >
> > Much like experimental I'm not sure how needed this change is.  The
> > help section does say to leave it disabled by default, if unsure.  If
> > you merge it I won't object but this might be fixing an imaginary
> > problem.
> 
> Architectures without common clock support won't build with this option
> enabled (multiple definition of clk_enable etc), so I think this should
> not be user visible.

I've applied this patch now.

	Arnd

commit c173033d154e9792b1b5059783b802f82536d48f
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Mar 17 21:10:51 2012 +0000

    clk: make CONFIG_COMMON_CLK invisible
    
    All platforms that use the common clk infrastructure should select
    COMMON_CLK from platform code, and on all other platforms, it must
    not be enabled, so there is no point making the option visible to
    users, and when it is visible, we break randconfig builds.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 2eaf17e..82bcfbd 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -10,18 +10,14 @@ config HAVE_MACH_CLKDEV
 	bool
 
 menuconfig COMMON_CLK
-	bool "Common Clock Framework"
+	bool
 	select HAVE_CLK_PREPARE
 	---help---
 	  The common clock framework is a single definition of struct
 	  clk, useful across many platforms, as well as an
 	  implementation of the clock API in include/linux/clk.h.
 	  Architectures utilizing the common struct clk should select
-	  this automatically, but it may be necessary to manually select
-	  this option for loadable modules requiring the common clock
-	  framework.
-
-	  If in doubt, say "N".
+	  this option.
 
 if COMMON_CLK
 

