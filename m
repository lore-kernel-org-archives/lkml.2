Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab0CaAM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:12:58 -0400
Received: from kroah.org ([198.145.64.141]:51913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab0C3XRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:50 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:20 2010
Message-Id: <20100330225619.674623653@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [034/116] e1000e: enable new 82567V-3 device
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 9e135a2e6266eba276f33c404a2478499bc07ff5 upstream.

This new PCI device ID is for a new combination of MAC and PHY both of
which already have supporting code in the driver, just not yet in this
combination.  During validation of the device, an intermittent issue was
discovered with waking it from a suspended state which can be resolved with
the pre-existing workaround to disable gigabit speed prior to suspending.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/hw.h      |    1 +
 drivers/net/e1000e/ich8lan.c |    1 +
 drivers/net/e1000e/netdev.c  |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/net/e1000e/hw.h
+++ b/drivers/net/e1000e/hw.h
@@ -356,6 +356,7 @@ enum e1e_registers {
 #define E1000_DEV_ID_80003ES2LAN_COPPER_SPT	0x10BA
 #define E1000_DEV_ID_80003ES2LAN_SERDES_SPT	0x10BB
 
+#define E1000_DEV_ID_ICH8_82567V_3		0x1501
 #define E1000_DEV_ID_ICH8_IGP_M_AMT		0x1049
 #define E1000_DEV_ID_ICH8_IGP_AMT		0x104A
 #define E1000_DEV_ID_ICH8_IGP_C			0x104B
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -3209,6 +3209,7 @@ void e1000e_disable_gig_wol_ich8lan(stru
 	u32 phy_ctrl;
 
 	switch (hw->mac.type) {
+	case e1000_ich8lan:
 	case e1000_ich9lan:
 	case e1000_ich10lan:
 	case e1000_pchlan:
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -5360,6 +5360,7 @@ static struct pci_device_id e1000_pci_tb
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH8_IGP_C), board_ich8lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH8_IGP_M), board_ich8lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH8_IGP_M_AMT), board_ich8lan },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH8_82567V_3), board_ich8lan },
 
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IFE), board_ich9lan },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_ICH9_IFE_G), board_ich9lan },


