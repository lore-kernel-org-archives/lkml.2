Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2JHGAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:00:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50130 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897Ab2JHGAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:00:10 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <kishon@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] ocp2scp: add non-dt support
Date: Mon, 8 Oct 2012 11:29:40 +0530
Message-ID: <1349675983-23803-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series allows ocp2scp driver to create its child devices
from the platform data.

In omap platforms, usb phy is connected to ocp2scp and usb phy is needed
for MUSB to be functional. When ocp2scp driver was added, it had only dt
support which means it wont create usb phy devices for non-dt boot.

This patch series adds non-dt support to ocp2scp and this series is needed
for getting MUSB functional in non-dt boot.

Changes from v1:
* Fixed Sergei's comments on memory leaks

This patch series is rebased on linux-next. 
commit: 080aa9c61ad0a6ed17de5643b32bb4660a0eb29d
Let me know if it had to be based on some other tree/commit.

Did a quick testing for g_zero enumeration in panda board.

Kishon Vijay Abraham I (3):
  drivers: bus: ocp2scp: add pdata support
  ARM: OMAP4: add _dev_attr_ to ocp2scp for representing usb_phy
  ARM: OMAP: ocp2scp: create omap device for ocp2scp

 arch/arm/mach-omap2/devices.c              |   76 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   28 ++++++++++
 drivers/bus/omap-ocp2scp.c                 |   67 ++++++++++++++++++++++--
 include/linux/platform_data/omap_ocp2scp.h |   31 ++++++++++++
 4 files changed, 199 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/platform_data/omap_ocp2scp.h

-- 
1.7.9.5

