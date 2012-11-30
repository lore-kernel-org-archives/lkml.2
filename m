Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992450Ab2K3SwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:52:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:57677 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161056Ab2K3Str (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Hay <joshua.a.hay@intel.com>,
        Phil Schmitt <phillip.j.schmitt@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Abdallah Chatila <Abdallah.Chatila@ericsson.com>
Subject: [ 27/37] ixgbe: add support for X540-AT1
Date: Fri, 30 Nov 2012 10:46:14 -0800
Message-Id: <20121130183900.172141894@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/ixgbe/ixgbe_common.c |    1 +
 drivers/net/ixgbe/ixgbe_main.c   |    2 ++
 drivers/net/ixgbe/ixgbe_type.h   |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/net/ixgbe/ixgbe_common.c
+++ b/drivers/net/ixgbe/ixgbe_common.c
@@ -3181,6 +3181,7 @@ static s32 ixgbe_device_supports_autoneg
 
 	switch (hw->device_id) {
 	case IXGBE_DEV_ID_X540T:
+	case IXGBE_DEV_ID_X540T1:
 		return 0;
 	case IXGBE_DEV_ID_82599_T3_LOM:
 		return 0;
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -129,6 +129,8 @@ static DEFINE_PCI_DEVICE_TABLE(ixgbe_pci
 	 board_82599 },
 	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_82599_LS),
 	 board_82599 },
+	{PCI_VDEVICE(INTEL, IXGBE_DEV_ID_X540T1),
+	 board_X540 },
 
 	/* required last entry */
 	{0, }
--- a/drivers/net/ixgbe/ixgbe_type.h
+++ b/drivers/net/ixgbe/ixgbe_type.h
@@ -64,6 +64,7 @@
 #define IXGBE_SUBDEV_ID_82599_KX4_KR_MEZZ  0x000C
 #define IXGBE_DEV_ID_82599_LS            0x154F
 #define IXGBE_DEV_ID_X540T               0x1528
+#define IXGBE_DEV_ID_X540T1              0x1560
 
 /* General Registers */
 #define IXGBE_CTRL      0x00000


