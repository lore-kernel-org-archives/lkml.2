Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab1LND6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:58:35 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:36768 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676Ab1LND6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:58:33 -0500
From: Mike Turquette <mturquette@linaro.org>
To: linux@arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jeremy.kerr@canonical.com,
        paul@pwsan.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, grant.likely@secretlab.ca,
        sboyd@quicinc.com, shawn.guo@freescale.com, skannan@quicinc.com,
        magnus.damm@gmail.com, arnd.bergmann@linaro.org, eric.miao@linaro.org,
        richard.zhao@linaro.org, mturquette@linaro.org, mturquette@ti.com,
        andrew@lunn.ch
Subject: [PATCH v4 0/6] common clk framework
Date: Tue, 13 Dec 2011 19:53:52 -0800
Message-Id: <1323834838-2206-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Turquette <mturquette@ti.com>

The common clk framework is an attempt to define a generic struct clk
which most platforms can use to build a clk tree and perform a set of
well-defined operations.

The previous patchset, v3, can be found at,
http://article.gmane.org/gmane.linux.kernel/1218622

New stuff in v4:
 * clk rate change notifiers
 * clk debug info via debugfs (instead of sysfs)
 * lots of bug fixes

Stuff that is known to be missing in v4:
 * basic mux and divider clk types
 * fix for migrating clk_prepare_count/clk_enable_count in
   clk_set_parent
 * minor rework comments from v3
 * Documentation/clk.txt needs love

All of the mising items above will be rolled into v5 ASAP.  I wanted to
go ahead and push out the new notifier changes for review and gather
comments on those since those were a big gap in the v3 patchset.

Paul W. also had some good comments about the greater clk API, and the
opportunity to fix some of that stuff while this patchset is still under
discussion.  I didn't address those here because they require more
thought, and more comments from reviewers.

Finally, OMAP4 support for the common struct clk will be posted
immediately after this patch series to LAKML and LOML, along with some
hack patches that show how to use the recursive clk_set_rate for
propagating rate changes up the tree for CPUfreq and how to use the new
clk rate change notifiers in a driver.

Mike Turquette (6):
  clk: Kconfig: add entry for HAVE_CLK_PREPARE
  Documentation: common clk API
  clk: introduce the common clock framework
  clk: introduce rate change notifiers
  clk: basic gateable and fixed-rate clks
  clk: export the clk tree topology to debugfs

 Documentation/clk.txt   |  312 +++++++++++++++
 drivers/clk/Kconfig     |   23 ++
 drivers/clk/Makefile    |    4 +-
 drivers/clk/clk-basic.c |  208 ++++++++++
 drivers/clk/clk.c       |  992 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk.h     |  230 +++++++++++-
 6 files changed, 1765 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/clk.txt
 create mode 100644 drivers/clk/clk-basic.c
 create mode 100644 drivers/clk/clk.c

-- 
1.7.5.4

