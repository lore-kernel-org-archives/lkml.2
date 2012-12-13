Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab2LMOUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:20:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45088 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405Ab2LMOOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Hay <joshua.a.hay@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 220/241] ixgbe: add support for X540-AT1
Date: Thu, 13 Dec 2012 11:59:45 -0200
Message-Id: <1355407206-17100-221-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "joshua.a.hay@intel.com" <joshua.a.hay@intel.com>

commit df376f0de167754da9b3ece4afdb5bb8bf3fbf3e upstream.

This patch adds device support for Ethernet Controller X540-AT1.

Signed-off-by: Josh Hay <joshua.a.hay@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |    2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |    1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 77ac41f..4352b2a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -70,6 +70,7 @@ static s32 ixgbe_device_supports_autoneg_fc(struct ixgbe_hw *hw)
 
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		return 0;
 	case IXGBE_DEV_ID_82599_T3_LOM:
 		return 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index e242104..7c0878f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -114,6 +114,7 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci_tbl) = {
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1), board_X540 },
 	/* required last entry */
 	{0, }
 };
@@ -6953,6 +6954,7 @@ int ixgbe_wol_supported(struct ixgbe_adapter *adapter, u16 device_id,
 		is_wol_supported = 1;
 		break;
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		/* check eeprom to see if enabled wol */
 		if ((wol_cap == IXGBE_DEVICE_CAPS_WOL_PORT0_1) ||
 		    ((wol_cap == IXGBE_DEVICE_CAPS_WOL_PORT0) &&
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 204848d..118f4db 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -67,6 +67,7 @@
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
 #define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
+#define IXGBE_DEV_ID_X540T1              0x1560
 
 /* VF Device IDs */
 #define IXGBE_DEV_ID_82599_VF           0x10ED
-- 
1.7.9.5

