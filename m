Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946534Ab2ERXFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946505Ab2ERXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:12 -0400
Message-Id: <20120518211604.114318868@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [ 51/54] pch_gbe: support ML7831 IOH
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>

commit 7756332f5b64c9c1535712b9679792e8bd4f0019 upstream.

Support new device OKI SEMICONDUCTOR ML7831 IOH(Input/Output Hub)

ML7831 is for general purpose use.
ML7831 is companion chip for Intel Atom E6xx series.
ML7831 is completely compatible for Intel EG20T PCH.

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/Kconfig                |   11 ++++++-----
 drivers/net/pch_gbe/pch_gbe_main.c |   10 ++++++++++
 2 files changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2543,7 +2543,7 @@ config S6GMAC
 source "drivers/net/stmmac/Kconfig"
 
 config PCH_GBE
-	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GbE"
+	tristate "Intel EG20T PCH/OKI SEMICONDUCTOR IOH(ML7223/ML7831) GbE"
 	depends on PCI
 	select MII
 	---help---
@@ -2556,10 +2556,11 @@ config PCH_GBE
 	  This driver enables Gigabit Ethernet function.
 
 	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
-	  Output Hub), ML7223.
-	  ML7223 IOH is for MP(Media Phone) use.
-	  ML7223 is companion chip for Intel Atom E6xx series.
-	  ML7223 is completely compatible for Intel EG20T PCH.
+	  Output Hub), ML7223/ML7831.
+	  ML7223 IOH is for MP(Media Phone) use. ML7831 IOH is for general
+	  purpose use.
+	  ML7223/ML7831 is companion chip for Intel Atom E6xx series.
+	  ML7223/ML7831 is completely compatible for Intel EG20T PCH.
 
 endif # NETDEV_1000
 
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -39,6 +39,9 @@ const char pch_driver_version[] = DRV_VE
 #define PCI_VENDOR_ID_ROHM			0x10db
 #define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
 
+/* Macros for ML7831 */
+#define PCI_DEVICE_ID_ROHM_ML7831_GBE		0x8802
+
 #define PCH_GBE_TX_WEIGHT         64
 #define PCH_GBE_RX_WEIGHT         64
 #define PCH_GBE_RX_BUFFER_WRITE   16
@@ -2457,6 +2460,13 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gbe_p
 	 .subvendor = PCI_ANY_ID,
 	 .subdevice = PCI_ANY_ID,
 	 .class = (PCI_CLASS_NETWORK_ETHERNET << 8),
+	 .class_mask = (0xFFFF00)
+	 },
+	{.vendor = PCI_VENDOR_ID_ROHM,
+	 .device = PCI_DEVICE_ID_ROHM_ML7831_GBE,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 .class = (PCI_CLASS_NETWORK_ETHERNET << 8),
 	 .class_mask = (0xFFFF00)
 	 },
 	/* required last entry */


