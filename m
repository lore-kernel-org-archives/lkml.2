Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab1ITOaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 10:30:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1ITOaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 10:30:15 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        <tony@atomide.com>, <khilman@ti.com>, <johnstul@us.ibm.com>,
        <vishwanath.bs@ti.com>, Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/5 v10] mfd: omap: usb: Runtime PM support for EHCI and OHCI drivers
Date: Tue, 20 Sep 2011 19:57:24 +0530
Message-ID: <1316528849-18247-1-git-send-email-keshava_mgowda@ti.com>
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

