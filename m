Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab1ION0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:26:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37678 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933706Ab1IONZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:25:55 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b-cousson@ti.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <paul@pwsan.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/5 v9] mfd: omap: usb: Runtime PM support for EHCI and OHCI drivers
Date: Thu, 15 Sep 2011 18:52:45 +0530
Message-ID: <1316092970-2440-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The Hwmod structures and Runtime PM features are implemented
For EHCI and OHCI drivers of OMAP3 and OMAP4.
The global suspend/resume of EHCI and OHCI
is validated on OMAP3430 sdp board with these patches.

these patches are rebased to kevin's pm branch and
usbhs latest mainline kernel patches

TODO:
   - Adding pad configurations to Hwmods
   - Aggressive clock cutting in usb bus suspends
   - Remote Wakeup implementation using irq-chaining


Benoit Cousson (1):
  arm: omap: usb: ehci and ohci hwmod structures for omap4

Keshava Munegowda (4):
  arm: omap: usb: ehci and ohci hwmod structures for omap3
  arm: omap: usb: register hwmods of usbhs
  arm: omap: usb: device name change for the clk names of usbhs
  mfd: omap: usb: Runtime PM support

 arch/arm/mach-omap2/clock3xxx_data.c       |   26 +-
 arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  281 +++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  247 ++++++++++
 arch/arm/mach-omap2/usb-host.c             |  114 ++---
 arch/arm/plat-omap/include/plat/usb.h      |    3 -
 drivers/mfd/omap-usb-host.c                |  733 +++++++++++-----------------
 drivers/usb/host/ehci-omap.c               |   17 +-
 drivers/usb/host/ohci-omap3.c              |   18 +-
 9 files changed, 891 insertions(+), 558 deletions(-)

