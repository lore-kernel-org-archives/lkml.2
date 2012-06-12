Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab2FLOmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:42:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54900 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2FLOmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:42:03 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        sboyd@codeaurora.org, skannan@codeaurora.org, shawn.guo@linaro.org,
        s.hauer@pengutronix.de, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 0/4] DT clock bindings
Date: Tue, 12 Jun 2012 09:41:47 -0500
Message-Id: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series defines clock bindings for Device-Tree and adds kernel
support using the common clock infrastructure. The last patch enables
DT clock support for the Calxeda Highbank platform.

I'm posting this again to solicit further review. There has been some
discussion[1], but no definite path forward. This series is not changed
from the last post other than rebasing to v3.5-rc2.

Rob

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-May/100932.html

Grant Likely (2):
  clk: add DT clock binding support
  clk: add DT fixed-clock binding support

Rob Herring (2):
  dt: add clock binding doc to primecell bindings
  clk: add highbank clock support

 .../devicetree/bindings/arm/primecell.txt          |    6 +
 .../devicetree/bindings/clock/calxeda.txt          |   17 +
 .../devicetree/bindings/clock/clock-bindings.txt   |  117 +++++++
 .../devicetree/bindings/clock/fixed-clock.txt      |   21 ++
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/highbank.dts                     |   91 +++++-
 arch/arm/mach-highbank/Makefile                    |    2 +-
 arch/arm/mach-highbank/clock.c                     |   62 ----
 arch/arm/mach-highbank/highbank.c                  |    7 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-fixed-rate.c                       |   23 ++
 drivers/clk/clk-highbank.c                         |  345 ++++++++++++++++++++
 drivers/clk/clk.c                                  |  140 ++++++++
 drivers/clk/clkdev.c                               |   77 +++++
 include/linux/clk-provider.h                       |   16 +
 include/linux/clk.h                                |   19 ++
 16 files changed, 881 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
 create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt
 delete mode 100644 arch/arm/mach-highbank/clock.c
 create mode 100644 drivers/clk/clk-highbank.c

-- 
1.7.9.5

