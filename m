Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2LJKUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:20:55 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59142 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2LJKUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:20:52 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 00/23] OMAP USB Host cleanup
Date: Mon, 10 Dec 2012 12:20:10 +0200
Message-ID: <1355134833-5199-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset addresses the following

- Avoid addressing clocks one by one by name and use a for loop + bunch
  of cleanups.
- Get number of channels/ports dynamically either from revision register
  or from platform data. Avoids getting clocks that are not present.
- Add OMAP5 and HSIC mode (Not tested)

v4:
- Added appropriate maintainers in to/cc
- minor print message fix in patch 23 to maintain consistency

v3:
- Rebased on arm-soc/for-next commit f979306c4d38d213c6977aaf3b1115e8ded71e3a
- Rearranged patch that get rids of cpu_is_omap..() macros
- Coding style fixes

v2:
- Clocks are allocated dynamically based on number of ports available
on the platform
- Reduced console spam if non critical clocks are not found on the platform.
- Get rid of cpu_is_.. macros from USB host driver.

cheers,
-roger

---
Roger Quadros (23):
  mfd: omap-usb-host: get rid of cpu_is_omap..() macros
  mfd: omap-usb-tll: Avoid creating copy of platform data
  mfd: omap-usb-tll: Fix channel count detection
  mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
  mfd: omap-usb-tll: Clean up clock handling
  mfd: omap-usb-tll: introduce and use mode_needs_tll()
  mfd: omap-usb-tll: Check for missing platform data in probe
  mfd: omap-usb-tll: Fix error message
  mfd: omap-usb-tll: serialize access to TLL device
  mfd: omap-usb-tll: Add OMAP5 revision and HSIC support
  mfd: omap_usb_host: Avoid creating copy of platform_data
  mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
  mfd: omap-usb-host: know about number of ports from revision register
  mfd: omap-usb-host: override number of ports from platform data
  mfd: omap-usb-host: cleanup clock management code
  ARM: OMAP2+: clock data: Merge utmi_px_gfclk into
    usb_host_hs_utmi_px_clk
  mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
  mfd: omap-usb-host: Get rid of unnecessary spinlock
  mfd: omap-usb-host: clean up omap_usbhs_init()
  USB: ehci-omap: Don't free gpios that we didn't request
  ARM: OMAP3: clock data: get rid of unused USB host clock aliases and
    dummies
  ARM: OMAP4: clock data: get rid of unused USB host clock aliases
  mfd: omap-usb-host: Don't spam console on clk_set_parent failure

 arch/arm/mach-omap2/cclock3xxx_data.c  |   13 -
 arch/arm/mach-omap2/cclock44xx_data.c  |   55 +++--
 arch/arm/mach-omap2/usb-host.c         |    5 +
 arch/arm/mach-omap2/usb.h              |    1 +
 drivers/mfd/omap-usb-host.c            |  474 ++++++++++++++++++--------------
 drivers/mfd/omap-usb-tll.c             |  244 +++++++++--------
 drivers/usb/host/ehci-omap.c           |    8 -
 include/linux/platform_data/usb-omap.h |    4 +
 8 files changed, 451 insertions(+), 353 deletions(-)

-- 
1.7.4.1

