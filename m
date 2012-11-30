Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993354Ab2K3TJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:09:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:59642 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993032Ab2K3TCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 14:02:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Hay <joshua.a.hay@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Abdallah Chatila <Abdallah.Chatila@ericsson.com>
Subject: [ 41/54] ixgbe: add support for X540-AT1
Date: Fri, 30 Nov 2012 10:56:12 -0800
Message-Id: <20121130185212.064422243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185207.894301294@linuxfoundation.org>
References: <20121130185207.894301294@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "joshua.a.hay@intel.com" <joshua.a.hay@intel.com>

commit df376f0de167754da9b3ece4afdb5bb8bf3fbf3e upstream.

This patch adds device support for Ethernet Controller X540-AT1.

Signed-off-by: Josh Hay <joshua.a.hay@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Abdallah Chatila <Abdallah.Chatila@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |    2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h   |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -70,6 +70,7 @@ static s32 ixgbe_device_supports_autoneg
 
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		return 0;
 	case IXGBE_DEV_ID_82599_T3_LOM:
 		return 0;
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -114,6 +114,7 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1), board_X540 },
 	/* required last entry */
 	{0, }
 };
@@ -7010,6 +7011,7 @@ int ixgbe_wol_supported(struct ixgbe_ada
 		is_wol_supported = 1;
 		break;
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		/* check eeprom to see if enabled wol */
 		if ((wol_cap == IXGBE_DEVICE_CAPS_WOL_PORT0_1) ||
 		    ((wol_cap == IXGBE_DEVICE_CAPS_WOL_PORT0) &&
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -65,6 +65,7 @@
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
 #define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
+#define IXGBE_DEV_ID_X540T1              0x1560
 
 /* VF Device IDs */
 #define IXGBE_DEV_ID_82599_VF           0x10ED


