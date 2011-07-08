Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1GHLDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 07:03:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37178 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620Ab1GHLDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 07:03:34 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <keshava_mgowda@ti.com>, <balbi@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <khilman@ti.com>, <b-cousson@ti.com>, <paul@pwsan.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>, <kishon@ti.com>
Subject: [PATCH 0/6 v3] arm: omap: usb: Runtime PM support for EHCI and OHCI drivers
Date: Fri, 8 Jul 2011 16:32:39 +0530
Message-ID: <1310122965-23612-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hwmod structures and Runtime PM features are implemented
For EHCI and OHCI drivers of OMAP3 and OMAP4.
The global suspend/resume of EHCI and OHCI
is validated on OMAP3430 sdp board with these patches.

V3:
Set MSTANDBY_SMART_WKUP for idlemode of usbhost
Rebased on top of git://gitorious.org/omap-pm/linux.git
Branch: for_3.1/3_hwmod_fixes
commit 213ca8a3a8d73225f2f5304ab3a68c6eda0f6d1b
Author: Benoit Cousson <b-cousson@ti.com>
Date:   Fri Jul 1 13:52:03 2011 +0200

    OMAP: hwmod: Move pr_debug to improve the readability
    
    Sligtly move the pr_debug at the top of the function
    to trace the entry even if the first test is failing.
    That help understanding that we entered the function
    but failed in it.
    
    Move the _enable last part out of the test to reduce
    indentation and improve readability.
    
    Signed-off-by: Benoit Cousson <b-cousson@ti.com>
    Cc: Paul Walmsley <paul@pwsan.com>

Benoit Cousson (1):
 arm: omap: usb: ehci and ohci hwmod structures for omap4

Keshava Munegowda (5):
  arm: omap: usb: ehci and ohci hwmod structures for omap3
  arm: omap: usb: register hwmods of usbhs
  arm: omap: usb: device name change for the clk names of usbhs
  arm: omap: usb: Runtime PM support
  arm: omap: usb: global Suspend and resume support of ehci and ohci

 arch/arm/mach-omap2/clock3xxx_data.c       |   28 +-
 arch/arm/mach-omap2/clock44xx_data.c       |   10 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  279 +++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  236 +++++++++++
 arch/arm/mach-omap2/usb-host.c             |  113 +++---
 arch/arm/plat-omap/include/plat/usb.h      |    3 -
 drivers/mfd/omap-usb-host.c                |  620 +++++++++++++---------------
 drivers/usb/host/ehci-omap.c               |   36 ++-
 drivers/usb/host/ohci-omap3.c              |   33 ++-
 9 files changed, 915 insertions(+), 443 deletions(-)

