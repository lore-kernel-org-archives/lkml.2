Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab2BCWfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 17:35:22 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62787 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753664Ab2BCWfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 17:35:20 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, shawn.guo@linaro.org,
        b-cousson@ti.com, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v4 0/4] generic irq chip domain support
Date: Fri,  3 Feb 2012 16:35:08 -0600
Message-Id: <1328308512-22594-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This series adds irq domain support for generic irq chip and updates
pl061 gpio and imx tzic to use it.

Once again, this is has been significantly re-worked from the previous
version. It's simply not possible to add domain support in a transparent
way. So now a wrapper function is added to setup a domain and alloc and
setup N gen irq chips.

There was some discussion about supporting multiple banks of less than 32
irqs per bank. Looking at all users of generic irq chip, this doesn't
appear to be needed. All users are either a single generic irq chip per
node or have 32 irqs per bank. Both are supported by this patch series.
If bank masking is needed, it can be added later.

This is based on Grant Likely's irq domain work and is available here:

git://sources.calxeda.com/kernel/linux.git pl061-domain-v4

Rob

Rob Herring (4):
  ARM: kconfig: always select IRQ_DOMAIN
  irq: add irq_domain support to generic-chip
  ARM: imx: add irq domain support to tzic
  gpio: pl061: enable interrupts with DT style binding

 .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
 arch/arm/Kconfig                                   |    2 +-
 arch/arm/common/Kconfig                            |    2 -
 arch/arm/plat-mxc/tzic.c                           |   23 ++--
 drivers/gpio/gpio-pl061.c                          |   48 +++---
 include/linux/irq.h                                |   15 ++
 kernel/irq/generic-chip.c                          |  154 +++++++++++++++++---
 7 files changed, 198 insertions(+), 61 deletions(-)

-- 
1.7.5.4

