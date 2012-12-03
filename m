Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab2LCOmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:42:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43910 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490Ab2LCOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:54 -0500
Message-Id: <20121203143152.098622574@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "joshua.a.hay@intel.com" <joshua.a.hay@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 32/89] ixgbe: add support for X540-AT1
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "joshua.a.hay@intel.com" <joshua.a.hay@intel.com>

commit df376f0de167754da9b3ece4afdb5bb8bf3fbf3e upstream.

This patch adds device support for Ethernet Controller X540-AT1.

Signed-off-by: Josh Hay <joshua.a.hay@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c  |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |    2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h    |    1 +
 4 files changed, 5 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -3157,6 +3157,7 @@ static s32 ixgbe_device_supports_autoneg
 
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		return 0;
 	case IXGBE_DEV_ID_82599_T3_LOM:
 		return 0;
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -107,6 +107,7 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1), board_X540 },
 	/* required last entry */
 	{0, }
 };
@@ -7612,6 +7613,7 @@ static int __devinit ixgbe_probe(struct
 		adapter->wol = IXGBE_WUFC_MAG;
 		break;
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		/* Check eeprom to see if it is enabled */
 		hw->eeprom.ops.read(hw, 0x2c, &adapter->eeprom_cap);
 		wol_cap = adapter->eeprom_cap & IXGBE_DEVICE_CAPS_WOL_MASK;
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -66,6 +66,7 @@
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
 #define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
+#define IXGBE_DEV_ID_X540T1              0x1560
 
 /* VF Device IDs */
 #define IXGBE_DEV_ID_82599_VF           0x10ED


