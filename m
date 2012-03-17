Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2CQJGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 05:06:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61821 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2CQJGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 05:06:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Turquette, Mike" <mturquette@ti.com>
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
Date: Sat, 17 Mar 2012 09:05:32 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com> <CAJOA=zPmy7Dwzw8EOCW_+cvy2Dv=w0TPUq7Zg_s=Y0rs+v+u2w@mail.gmail.com>
In-Reply-To: <CAJOA=zPmy7Dwzw8EOCW_+cvy2Dv=w0TPUq7Zg_s=Y0rs+v+u2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203170905.33191.arnd@arndb.de>
X-Provags-ID: V02:K0:Re8/0Q/VyVfaZN1kUlRE9ffQ/0tFHXgswrz4RNm+oqN
 Eq4Uj7PJWB2Nl2LgwMHbr7RUF7/Hke4YCnui2CfG4ONN7Az/XA
 QOhPRFml8Qm667d/In9pDbNeWi61wOBSgLLya8WloidXpIj3ak
 ys0/F5t75mK4/cTFD1biETtzOqrvrTIh717PB0bhOyOdIZHILO
 L+SPLzm9cvT0quHtSpfVJ68CFEu1i58YFNt978ZGp7uBsPLgJc
 OxyU2WrErXzwaA1uYeFAkH2qvv50EJBm6nBUoduqV148Mir2lo
 UYX6poQ4QZVI0q8SIMsA+YhRXv75P7f9O0jUy3rYWzUpAXRA0G
 GvzpmH9ODtQBGFhf1CJE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012, Turquette, Mike wrote:
> On Fri, Mar 16, 2012 at 3:21 PM, Paul Walmsley <paul@pwsan.com> wrote:
> > From: Paul Walmsley <paul@pwsan.com>
> > Date: Fri, 16 Mar 2012 16:06:30 -0600
> > Subject: [PATCH] clk: mark the common clk code as EXPERIMENTAL for now
> >
> > Mark the common clk code as depending on CONFIG_EXPERIMENTAL.  The API
> > is not well-defined and both it and the underlying mechanics are likely
> > to need significant changes to support non-trivial uses of the rate
> > changing code, such as DVFS with external I/O devices.  So any platforms
> > that switch their implementation over to this may need to revise much
> > of their driver code and revalidate their implementations until the
> > behavior of the code is better-defined.
> >
> > A good time for removing this EXPERIMENTAL designation would be after at
> > least two platforms that do DVFS on groups of external I/O devices have
> > ported their clock implementations over to the common clk code.
> >
> > Signed-off-by: Paul Walmsley <paul@pwsan.com>
> > Cc: Mike Turquette <mturquette@ti.com>
> 
> ACK.  This will set some reasonable expectations while things are in flux.
> 
> Arnd are you willing to take this in?

I think it's rather pointless, because the option is not going to
be user selectable but will get selected by the platform unless I'm
mistaken. The platform maintainers that care already know the state
of the framework. Also, there are no user space interfaces that we
have to warn users about not being stable, because the framework
is internal to the kernel.

However, I wonder whether we need the patch below to prevent
users from accidentally enabling COMMON_CLK on platforms that
already provide their own implementation.

	Arnd

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 2eaf17e..a0a83de 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -12,7 +12,7 @@ config HAVE_MACH_CLKDEV

 menuconfig COMMON_CLK
-       bool "Common Clock Framework"
+	bool
        select HAVE_CLK_PREPARE
        ---help---
          The common clock framework is a single definition of struct
          clk, useful across many platforms, as well as an
