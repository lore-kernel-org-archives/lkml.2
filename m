Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1IFIff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:35:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:46745 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab1IFIfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:35:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,337,1312182000"; 
   d="scan'208";a="48422828"
Subject: [PATCH -next] drivers/net: Makefile, fix netconsole link order
From: Lin Ming <ming.m.lin@intel.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Sep 2011 16:35:29 +0800
Message-ID: <1315298129.16061.24.camel@snb>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88491d8(drivers/net: Kconfig & Makefile cleanup) causes a
regression that netconsole does not work if netconsole and network
device driver are build into kernel, because netconsole is linked before
network device driver.

Fixes it by moving netconsole.o after network device driver.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/net/Makefile |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index fa877cd..ec15311 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -14,7 +14,6 @@ obj-$(CONFIG_MACVTAP) += macvtap.o
 obj-$(CONFIG_MII) += mii.o
 obj-$(CONFIG_MDIO) += mdio.o
 obj-$(CONFIG_NET) += Space.o loopback.o
-obj-$(CONFIG_NETCONSOLE) += netconsole.o
 obj-$(CONFIG_PHYLIB) += phy/
 obj-$(CONFIG_RIONET) += rionet.o
 obj-$(CONFIG_TUN) += tun.o
@@ -66,3 +65,9 @@ obj-$(CONFIG_USB_USBNET)        += usb/
 obj-$(CONFIG_USB_ZD1201)        += usb/
 obj-$(CONFIG_USB_IPHETH)        += usb/
 obj-$(CONFIG_USB_CDC_PHONET)   += usb/
+
+#
+# If netconsole and network device driver are build-in,
+# netconsole must be linked after network device driver
+#
+obj-$(CONFIG_NETCONSOLE) += netconsole.o
-- 
1.7.2.5



