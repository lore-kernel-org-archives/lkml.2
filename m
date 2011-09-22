Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1IVWas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:30:48 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:42479 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754186Ab1IVWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:30:44 -0400
From: Mike Turquette <mturquette@ti.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        broonie@opensource.wolfsonmicro.com, tglx@linutronix.de,
        linus.walleij@stericsson.com, amit.kucheria@linaro.org,
        dsaxena@linaro.org, patches@linaro.org, linaro-dev@lists.linaro.org,
        paul@pwsan.com, grant.likely@secretlab.ca, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org, Mike Turquette <mturquette@ti.com>
Subject: [PATCH v2 0/7] Add a generic struct clk
Date: Thu, 22 Sep 2011 15:26:55 -0700
Message-Id: <1316730422-20027-1-git-send-email-mturquette@ti.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The goal of this series is to provide a cross-platform clock framework
that platforms can use to model their clock trees and perform common
operations on them.  Currently everyone re-invents their own clock tree
inside platform code which makes it impossible for drivers to use the
clock APIs safely across many platforms and for distro's to compile
multi-platform kernels which all redefine struct clk and its operations.

This is the second version of the common clock patches which were
originally posted by Jeremy Kerr and then re-posted with some additional
patches by Mark Brown.  Mark's re-post didn't have any changes done to
the original four patches from Jeremy which is why this series is "v2".

The changes in this series are minimal: I've folded in some of Mark's
fixes and most of the comments posted to his series as well as rebasing
on top of v3.1-rc7.  The design and functionality hasn't changed much
since Jeremy posted v1 of this series.  Propagating the rate change up
to the parent has been removed from clk_set_rate since that needs some
more thought.  I also dropped Mark's change to append a device's name to
a clk name since device tree might solve this neatly.  Again more
discussion around that would be good.

v1 of the series can be found at,
http://article.gmane.org/gmane.linux.kernel/1143182

Mark's re-post (v1+) can be found at,
http://article.gmane.org/gmane.linux.ports.arm.kernel/129889

Todo in follow-up patches:
clk_set_parent
Implement a *safe* upstream propagation for parent rate changes
Track tree topology and export to userspace (sysfs or debugfs)
Manage root clocks globally
Device tree support
Per-tree locking instead of framework-wide locking
Device driver rate-change notifiers

Jeremy Kerr (4):
  clk: Add a generic clock infrastructure
  clk: Implement clk_set_rate
  clk: Add fixed-rate clock
  clk: Add simple gated clock

Mark Brown (3):
  clk: Add Kconfig option to build all generic clk drivers
  clk: Add initial WM831x clock driver
  x86: Enable generic clk API on x86

 MAINTAINERS              |    1 +
 arch/x86/Kconfig         |    1 +
 drivers/clk/Kconfig      |   27 +++-
 drivers/clk/Makefile     |    4 +
 drivers/clk/clk-fixed.c  |   24 +++
 drivers/clk/clk-gate.c   |   78 ++++++++++
 drivers/clk/clk-wm831x.c |  386 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/clk.c        |  291 ++++++++++++++++++++++++++++++++++
 drivers/clk/clkdev.c     |    7 +
 include/linux/clk.h      |  179 ++++++++++++++++++++--
 10 files changed, 985 insertions(+), 13 deletions(-)
 create mode 100644 drivers/clk/clk-fixed.c
 create mode 100644 drivers/clk/clk-gate.c
 create mode 100644 drivers/clk/clk-wm831x.c
 create mode 100644 drivers/clk/clk.c

-- 
1.7.4.1

