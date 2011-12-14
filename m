Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1LNP3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:29:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1LNP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:29:21 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/9] irq domain for gen irq chip and pl061 DT irq support
Date: Wed, 14 Dec 2011 09:28:49 -0600
Message-Id: <1323876538-20406-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds irq_domain support to generic irq chip, converts the
pl061 gpio driver to use generic irq chip, and finally adds DT irq binding
support for pl061. The pl061 driver is also fixed to use 0 for no irq
instead of -1 or NO_IRQ.

The irq_domain support should be transparent to users of generic irq
chip. Shawn Guo has tested previous version with i.MX AVIC and his fixes
have been incorporated. Any testing by other users of generic irq chip
is appreciated.

This series is also dependent on:

irqdomain: export irq_domain_simple_ops for !CONFIG_OF
http://www.spinics.net/lists/arm-kernel/msg150290.html

gpio: pl061: drop extra check for NULL platform_data
http://www.spinics.net/lists/arm-kernel/msg151701.html

Tested on highbank and built all defconfigs.

Rob

Rob Herring (9):
  dt: add empty of_get_node/of_put_node functions
  irq: ensure domain hwirq is within range for DT translate
  irq: convert generic-chip to use irq_domain
  gpio: pl061: use chained_irq_* functions in irq handler
  gpio: pl061: convert to use 0 for no irq
  ARM: realview: convert pl061 no irq to be 0 instead of -1
  gpio: pl061: convert to use generic irq chip
  gpio: pl061: enable interrupts with DT style binding
  ARM: highbank: add interrupt properties to gpio nodes

 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 +++
 arch/arm/boot/dts/highbank.dts                     |    9 ++-
 arch/arm/mach-realview/realview_eb.c               |    3 -
 arch/arm/mach-realview/realview_pb1176.c           |    3 -
 arch/arm/mach-realview/realview_pb11mp.c           |    3 -
 arch/arm/mach-realview/realview_pba8.c             |    3 -
 arch/arm/mach-realview/realview_pbx.c              |    3 -
 drivers/gpio/Kconfig                               |    1 +
 drivers/gpio/gpio-pl061.c                          |  107 +++++++++-----------
 include/linux/amba/pl061.h                         |    2 +-
 include/linux/irq.h                                |    2 +-
 include/linux/of.h                                 |   29 +++---
 kernel/irq/Kconfig                                 |    1 +
 kernel/irq/generic-chip.c                          |   57 +++++++----
 kernel/irq/irqdomain.c                             |    3 +
 15 files changed, 126 insertions(+), 115 deletions(-)

-- 
1.7.5.4

