Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab2IFO4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:56:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45273 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab2IFO4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:56:11 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 0/3] omap: musb: Add device tree support
Date: Thu, 6 Sep 2012 20:25:28 +0530
Message-ID: <1346943331-18120-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds device tree support for MUSB.

The glue layer is now made to write to mailbox register (present in
control module) instead of calling phy layer to write to mailbox
register. Writing to mailbox register notifies the core of events like
device connect/disconnect.

Previously these patches were part of
[PATCH v7 0/7] omap: musb: Add device tree support

This patch series was created to contain only the *musb* part and it
also has one hwmod patch.

This patch series was created on
git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git musb

Kishon Vijay Abraham I (3):
  arm: omap: hwmod: add a new addr space in otg for writing to control
    module
  usb: musb: omap: write directly to mailbox instead of using phy
  usb: musb: omap: Add device tree support for omap musb glue

 Documentation/devicetree/bindings/usb/omap-usb.txt |   33 ++++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    5 +
 drivers/usb/musb/omap2430.c                        |  106 ++++++++++++++++++--
 drivers/usb/musb/omap2430.h                        |    9 ++
 4 files changed, 146 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt

-- 
1.7.9.5

