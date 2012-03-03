Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2CCIaG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 03:30:06 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:59917 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab2CCIaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 03:30:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.236.76.133 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
From: Mike Turquette <mturquette@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@ti.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v5 0/4] common clk framework
Date: Sat,  3 Mar 2012 00:28:57 -0800
Message-Id: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@ti.com>

The common clock framework defines a common struct clk as well as an
implementation of the clk api that unifies clock operations on various
platforms and devices.

The net result is consolidation of many different struct clk definitions
and platform-specific clock framework implementations.

I consider this version merge-worthy pending ACKs from the relevant
maintainers; namely Russell, Thomas and the platform folks interested in
porting to this framework.

I would like to thank everyone who participated in the common clk
sessions at Linaro Connect and ELC; the feedback was invaluable.

Also I would like to thank Shawn Guo, Richard Zhao, Saravana Kannan and
Magnus Damm for tirelessly updating their platforms for the last few
revisions of this patch series and providng excellent feedback each
time.

Major changes since v4:
 * rolled in TGLX's comments on overall design.  We now have,
   * proper handling of root clocks and orphan clocks
   * multi-parent clocks are handled in the core
   * struct clk is shielded from struct clk_foo and vice versa
     * this is a return to the previous struct clk_hw design
 * split basic clock types out into separate files
 * split headers up by purpose
   * clk.h remains the driver-level interface
     * declarations for rate change notifiers are the only additions
   * clk-provider.h is primary header for implementing clock operations
   * clk-private.h allows for static initialization of clock data
 * validation and bug fixes
 * rebased onto Linus' v3.3-rc5 tag

Patches can be pulled from:
git://git.linaro.org/people/mturquette/linux.git v3.3-rc5-clkv5

v4 can be found at,
http://article.gmane.org/gmane.linux.linaro.devel/8896/

v3 can be found at,
http://article.gmane.org/gmane.linux.kernel/1218622

Mike Turquette (4):
  Documentation: common clk API
  clk: Kconfig: add entry for HAVE_CLK_PREPARE
  clk: introduce the common clock framework
  clk: basic clock hardware types

 Documentation/clk.txt        |  201 +++++++
 drivers/clk/Kconfig          |   31 +
 drivers/clk/Makefile         |    2 +
 drivers/clk/clk-divider.c    |  199 +++++++
 drivers/clk/clk-fixed-rate.c |   81 +++
 drivers/clk/clk-gate.c       |  121 ++++
 drivers/clk/clk-mux.c        |  114 ++++
 drivers/clk/clk.c            | 1323 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-private.h  |  192 ++++++
 include/linux/clk-provider.h |  294 ++++++++++
 include/linux/clk.h          |   68 ++-
 11 files changed, 2621 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/clk.txt
 create mode 100644 drivers/clk/clk-divider.c
 create mode 100644 drivers/clk/clk-fixed-rate.c
 create mode 100644 drivers/clk/clk-gate.c
 create mode 100644 drivers/clk/clk-mux.c
 create mode 100644 drivers/clk/clk.c
 create mode 100644 include/linux/clk-private.h
 create mode 100644 include/linux/clk-provider.h

Cc: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergman <arnd.bergmann@linaro.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Deepak Saxena <dsaxena@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Andrew Lunn <andrew@lunn.ch>

-- 
1.7.5.4

