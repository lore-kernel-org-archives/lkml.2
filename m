Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2DIUZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 16:25:22 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33643 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab2DIUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 16:25:21 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/4] DT clock binding support
Date: Mon,  9 Apr 2012 15:24:57 -0500
Message-Id: <1334003101-17274-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This is yet another post of DT clock binding support. This adds support for
parsing clock data from DT and initializing clock trees using the common
clk infrastructure.

Functionally, this is mostly unchanged from the previous version. The major
change is the move of everything from drivers/of/clock.c and of_clk.h into
appropriate places in the core clock infrastructure. I've also squashed my
changes into Grant's original patches.

The highbank clock support is unchanged except for includes, so I have not
reposted it here.

The previous series is here:
http://www.spinics.net/lists/arm-kernel/msg164892.html

Rob

Grant Likely (2):
  clk: add DT clock binding support
  clk: add DT fixed-clock binding support

Rob Herring (2):
  clk: select CLKDEV_LOOKUP for COMMON_CLK
  clk: remove trailing whitespace from clk.h

 .../devicetree/bindings/clock/clock-bindings.txt   |  117 ++++++++++++++++
 .../devicetree/bindings/clock/fixed-clock.txt      |   22 +++
 drivers/clk/Kconfig                                |    1 +
 drivers/clk/clk-fixed-rate.c                       |   23 ++++
 drivers/clk/clk.c                                  |  140 ++++++++++++++++++++
 drivers/clk/clkdev.c                               |   77 +++++++++++
 include/linux/clk-provider.h                       |   16 +++
 include/linux/clk.h                                |   23 +++-
 8 files changed, 417 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/clock-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/clock/fixed-clock.txt

-- 
1.7.5.4

