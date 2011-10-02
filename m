Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1JBOuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 10:50:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772Ab1JBOrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 10:47:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Keshava Munegowda <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 18/30] omap-usb: automatically select MFD_OMAP_USB_HOST
Date: Sun,  2 Oct 2011 16:45:48 +0200
Message-Id: <1317566760-25681-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:winOtMr5sZgmQPceC0JtiwWJjkKmFRm51evxwtPI3Nn
 fm4IDhqc/9uZqDy3zsUc7WTa+PWIPyCjeGgwC6z1iWrmo78XIB
 J7V6MPz8Z7GzCmw2D768cTRrP/tLcuja4UhPzstzf1hydulwLe
 fcRSImwDsv3g78VVm1tWo+Kyc59PcZkLM+kNXDCI+ZRkFQ4eiG
 vMrvpoQMZ64ztpfzSPM8d2EVabBRXgNWDB/Kgg5u8dKAtygTMN
 a3OnyYcw9AfxZT7v+GQgbhr2I1UXJ1jfW5ND34WLyntdz9WEgr
 8eWUWVA33s4NXxhgwbkzZBSmXmCxsKXewb5L0jiFF8gU26b+Cl
 k24lCLoNSrum4RKPuYuQ4rwU2fZVko1nTiLcCe2Z7G0hyvJMjy
 cd19C/4RmyjLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ehci-omap and ohci-omap3 drivers both depend on the
omap-usb-host MFD support driver. By default, this is
automatically turned on, but it is possible to disable
the driver, which results in a link error.

This patch makes the option invisible so we always do
the right thing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 21574bd..48cce35 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -721,7 +721,7 @@ config MFD_WL1273_CORE
 	  audio codec.
 
 config MFD_OMAP_USB_HOST
-	bool "Support OMAP USBHS core driver"
+	bool
 	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
 	default y
 	help
-- 
1.7.5.4

