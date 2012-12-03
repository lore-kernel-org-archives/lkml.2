Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2LCOmH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:42:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43913 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2LCOgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:55 -0500
Message-Id: <20121203143151.959445796@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Emil Tantilov <emil.s.tantilov@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 31/89] ixgbe: add support for new 82599 device id
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Tantilov <emil.s.tantilov@intel.com>

commit 9e791e4a04c08868f02cd579a428a7268492e1b4 upstream.

Support for new 82599 based quad port adapter.

Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Tested-by: Phil Schmitt <phillip.j.schmitt@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h  |    1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index 4ae26a7..7720721 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -356,6 +356,7 @@ static enum ixgbe_media_type ixgbe_get_media_type_82599(struct ixgbe_hw *hw)
 	case IXGBE_DEV_ID_82599_SFP_FCOE:
 	case IXGBE_DEV_ID_82599_SFP_EM:
 	case IXGBE_DEV_ID_82599_SFP_SF2:
+	case IXGBE_DEV_ID_82599_SFP_SF_QP:
 	case IXGBE_DEV_ID_82599EN_SFP:
 		media_type = ixgbe_media_type_fiber;
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cd1f893..e27e4d1 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -106,6 +106,7 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci_tbl) = {
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF2), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS), board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599EN_SFP), board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_SFP_SF_QP), board_82599 },
 	/* required last entry */
 	{0, }
 };
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 242643a..7c5817f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -65,6 +65,7 @@
 #define IXGBE_SUBDEV_ID_82599_KX4_KR_MEZZ  0x000C
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
+#define IXGBE_DEV_ID_82599_SFP_SF_QP     0x154A
 
 /* VF Device IDs */
 #define IXGBE_DEV_ID_82599_VF           0x10ED


