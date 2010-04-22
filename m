Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab0DVToZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:44:25 -0400
Received: from kroah.org ([198.145.64.141]:41229 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab0DVT3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:16 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:19 2010
Message-Id: <20100422190919.219099032@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       "David S. Miller" <davem@davemloft.net>,
       maximilian attems <max@stro.at>
Subject: [133/197] igb: add support for 82576NS SerDes adapter
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit 747d49baaf4e3f4ad5ae77477830da026eeef69d upstream.

This patch adds the device ID necessary to support the 82576NS SerDes
adapter.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/e1000_82575.c |    1 +
 drivers/net/igb/e1000_hw.h    |    1 +
 drivers/net/igb/igb_main.c    |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/net/igb/e1000_82575.c
+++ b/drivers/net/igb/e1000_82575.c
@@ -81,6 +81,7 @@ static s32 igb_get_invariants_82575(stru
 		break;
 	case E1000_DEV_ID_82576:
 	case E1000_DEV_ID_82576_NS:
+	case E1000_DEV_ID_82576_NS_SERDES:
 	case E1000_DEV_ID_82576_FIBER:
 	case E1000_DEV_ID_82576_SERDES:
 	case E1000_DEV_ID_82576_QUAD_COPPER:
--- a/drivers/net/igb/e1000_hw.h
+++ b/drivers/net/igb/e1000_hw.h
@@ -42,6 +42,7 @@ struct e1000_hw;
 #define E1000_DEV_ID_82576_SERDES             0x10E7
 #define E1000_DEV_ID_82576_QUAD_COPPER        0x10E8
 #define E1000_DEV_ID_82576_NS                 0x150A
+#define E1000_DEV_ID_82576_NS_SERDES          0x1518
 #define E1000_DEV_ID_82576_SERDES_QUAD        0x150D
 #define E1000_DEV_ID_82575EB_COPPER           0x10A7
 #define E1000_DEV_ID_82575EB_FIBER_SERDES     0x10A9
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -63,6 +63,7 @@ static const struct e1000_info *igb_info
 static struct pci_device_id igb_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_NS), board_82575 },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_NS_SERDES), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_FIBER), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_SERDES), board_82575 },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_82576_SERDES_QUAD), board_82575 },


