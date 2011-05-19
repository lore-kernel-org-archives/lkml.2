Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab1ESSRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:17:45 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43935 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934017Ab1ESSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:40 -0400
X-Sasl-enc: 6eEuTWHew5coEYR2mPs4U83UQbfeHAqLhimOPwFPzrdB 1305828519
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:57 2011
Message-Id: <20110519180557.756634626@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [36/71] pch_gbe: support ML7223 IOH
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tomoya <tomoya-linux@dsn.okisemi.com>

commit b0e6baf5619a6fa3eaf43b55fdb4daa362c3c916 upstream.

Support new device OKI SEMICONDUCTOR ML7223 IOH(Input/Output Hub).
The ML7223 IOH is for MP(Media Phone) use.
The ML7223 is companion chip for Intel Atom E6xx series.
The ML7223 is completely compatible for Intel EG20T PCH.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/Kconfig                |    8 +++++++-
 drivers/net/pch_gbe/pch_gbe_main.c |   11 +++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2533,7 +2533,7 @@ config S6GMAC
 source "drivers/net/stmmac/Kconfig"
 
 config PCH_GBE
-	tristate "PCH Gigabit Ethernet"
+	tristate "Intel EG20T PCH / OKI SEMICONDUCTOR ML7223 IOH GbE"
 	depends on PCI
 	select MII
 	---help---
@@ -2545,6 +2545,12 @@ config PCH_GBE
 	  to Gigabit Ethernet.
 	  This driver enables Gigabit Ethernet function.
 
+	  This driver also can be used for OKI SEMICONDUCTOR IOH(Input/
+	  Output Hub), ML7223.
+	  ML7223 IOH is for MP(Media Phone) use.
+	  ML7223 is companion chip for Intel Atom E6xx series.
+	  ML7223 is completely compatible for Intel EG20T PCH.
+
 endif # NETDEV_1000
 
 #
--- a/drivers/net/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/pch_gbe/pch_gbe_main.c
@@ -34,6 +34,10 @@ const char pch_driver_version[] = DRV_VE
 #define PCH_GBE_COPYBREAK_DEFAULT	256
 #define PCH_GBE_PCI_BAR			1
 
+/* Macros for ML7223 */
+#define PCI_VENDOR_ID_ROHM			0x10db
+#define PCI_DEVICE_ID_ROHM_ML7223_GBE		0x8013
+
 #define PCH_GBE_TX_WEIGHT         64
 #define PCH_GBE_RX_WEIGHT         64
 #define PCH_GBE_RX_BUFFER_WRITE   16
@@ -2416,6 +2420,13 @@ static DEFINE_PCI_DEVICE_TABLE(pch_gbe_p
 	 .subvendor = PCI_ANY_ID,
 	 .subdevice = PCI_ANY_ID,
 	 .class = (PCI_CLASS_NETWORK_ETHERNET << 8),
+	 .class_mask = (0xFFFF00)
+	 },
+	{.vendor = PCI_VENDOR_ID_ROHM,
+	 .device = PCI_DEVICE_ID_ROHM_ML7223_GBE,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 .class = (PCI_CLASS_NETWORK_ETHERNET << 8),
 	 .class_mask = (0xFFFF00)
 	 },
 	/* required last entry */


