Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab2IKJKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 05:10:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48799 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab2IKJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 05:10:11 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <kishon@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <b-cousson@ti.com>, <rnayak@ti.com>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH v2 0/3] omap: musb: Add device tree support
Date: Tue, 11 Sep 2012 14:39:37 +0530
Message-ID: <1347354580-5895-1-git-send-email-kishon@ti.com>
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

Changes from v1:
* Added a comment in hwmod data to remove the control module data from
otg_hs once control driver is in place.
* Fixed the omap-usb Documentation to the correct compatible value
(Should be "ti,omap4-musb" or "ti,omap3-musb")

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
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    6 ++
 drivers/usb/musb/omap2430.c                        |  106 ++++++++++++++++++--
 drivers/usb/musb/omap2430.h                        |    9 ++
 4 files changed, 147 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/omap-usb.txt

-- 
1.7.9.5

