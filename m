Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1I2OKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:10:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59800 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab1I2OJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:09:02 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>, <khilman@ti.com>,
        <b-cousson@ti.com>, <paul@pwsan.com>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH 0/5 v12] mfd: omap: usb: Runtime PM support for EHCI and OHCI drivers
Date: Thu, 29 Sep 2011 19:37:16 +0530
Message-ID: <1317305241-611-1-git-send-email-keshava_mgowda@ti.com>
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

TODO:
  - Adding mux-information to Hwmods.
  - Aggressive Clock Management around USB bus suspend/resume.
  - Remote Wakeup support implementation using IO-ring Wakeup
    on EHCI/OHCI pads via PRCM IRQ chain handler.


In version 12:
  - The ehci, ohci and usb_host_hs hwmods combined as a single hwmod
    usb_host_hs.
  - for omap3
	the usbhost_ick and and usbtll_ick clocks are changed as interface
        clocks. The usbtll_fck, usbhost_48m_fck clocks are changed as main
        clocks and the 120mhz functional clock is changed to optional clock 
  - the usbhs mfd driver enable/disable this optional clock in 
    runtime_resume and runtime_suspend callbacks of pm_runtime_get_sync
    and pm_runtime_put_sync APIs.

Benoit Cousson (1):
  arm: omap: usb: ehci and ohci hwmod structures for omap4

Keshava Munegowda (4):
  arm: omap: usb: ehci and ohci hwmod structures for omap3
  arm: omap: usb: register hwmods of usbhs
  arm: omap: usb: device name change for the clk names of usbhs
  mfd: omap: usb: Runtime PM support

 arch/arm/mach-omap2/clock3xxx_data.c       |   26 +-
 arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  195 ++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  171 +++++++-
 arch/arm/mach-omap2/usb-host.c             |  100 ++---
 arch/arm/plat-omap/include/plat/usb.h      |    3 -
 drivers/mfd/omap-usb-host.c                |  748 +++++++++++-----------------
 drivers/usb/host/ehci-omap.c               |   17 +-
 drivers/usb/host/ohci-omap3.c              |   18 +-
 9 files changed, 727 insertions(+), 561 deletions(-)

