Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602Ab1ITUYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:24:15 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57918 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab1ITUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:24:14 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, marc.zyngier@arm.com, thomas.abraham@linaro.org,
        jamie@jamieiles.com, b-cousson@ti.com, shawn.guo@linaro.org,
        dave.martin@linaro.org, linux@arm.linux.org.uk,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 0/3] GIC OF bindings
Date: Tue, 20 Sep 2011 15:24:01 -0500
Message-Id: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Hopefully, this is the final or near final version of GIC binding support.

Changes from the previous version:
- SPIs and PPIs are numbered starting at 0. Now the gic has it's own irq
  domain translate function instead of the simple domain one.
- interrupt cell format has changed based on Grant's proposal.
- Dropped "ARM: gic: allow irq_start to be 0". Instead, the first 16 irqs
  are skipped and the domain irq_base adjusted accordingly.
- Added a fix to of_irq_find_parent when the parent == child.
- Renamed intc_desc.parent to intc_desc.interrupt_parent.
- Implemented Grant's algorithm for walking the list of interrupt
  controllers. Added a return value to interrupt init functions, so they
  don't get added to the parent list on a init failure.

The changes are significant enough that I did not include previous
acked/reviewed/tested-by's.

Rob

Rob Herring (3):
  of/irq: of_irq_find_parent: check for parent equal to child
  of/irq: introduce of_irq_init
  ARM: gic: add OF based initialization

 Documentation/devicetree/bindings/arm/gic.txt |   55 +++++++++++
 arch/arm/common/gic.c                         |   89 ++++++++++++++++-
 arch/arm/include/asm/hardware/gic.h           |   12 +++
 drivers/of/irq.c                              |  128 +++++++++++++++++++++++--
 include/linux/of_irq.h                        |    1 +
 5 files changed, 274 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/gic.txt

-- 
1.7.5.4

