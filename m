Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030303Ab2CSDij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 23:38:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40166 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030205Ab2CSDih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 23:38:37 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 3/4] igbvf: Use ETH_ALEN
Date: Sun, 18 Mar 2012 20:37:58 -0700
Message-Id: <49b440b7f5a9fa85ed5278e2663541283e32cad8.1332128181.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1332128181.git.joe@perches.com>
References: <cover.1332128181.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unnecessary #define and use memcpy
instead of a loop to copy an ethernet address.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/igbvf/defines.h |    4 ----
 drivers/net/ethernet/intel/igbvf/vf.c      |    7 ++-----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/defines.h b/drivers/net/ethernet/intel/igbvf/defines.h
index 33f40d3..3e18045 100644
--- a/drivers/net/ethernet/intel/igbvf/defines.h
+++ b/drivers/net/ethernet/intel/igbvf/defines.h
@@ -97,10 +97,6 @@
 #define E1000_ERR_MAC_INIT 5
 #define E1000_ERR_MBX      15
 
-#ifndef ETH_ADDR_LEN
-#define ETH_ADDR_LEN                 6
-#endif
-
 /* SRRCTL bit definitions */
 #define E1000_SRRCTL_BSIZEPKT_SHIFT                     10 /* Shift _right_ */
 #define E1000_SRRCTL_BSIZEHDRSIZE_MASK                  0x00000F00
diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index 1955197..30a6cc4 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -246,7 +246,7 @@ static void e1000_update_mc_addr_list_vf(struct e1000_hw *hw,
 	for (i = 0; i < cnt; i++) {
 		hash_value = e1000_hash_mc_addr_vf(hw, mc_addr_list);
 		hash_list[i] = hash_value & 0x0FFFF;
-		mc_addr_list += ETH_ADDR_LEN;
+		mc_addr_list += ETH_ALEN;
 	}
 
 	mbx->ops.write_posted(hw, msgbuf, E1000_VFMAILBOX_SIZE);
@@ -333,10 +333,7 @@ static void e1000_rar_set_vf(struct e1000_hw *hw, u8 * addr, u32 index)
  **/
 static s32 e1000_read_mac_addr_vf(struct e1000_hw *hw)
 {
-	int i;
-
-	for (i = 0; i < ETH_ADDR_LEN; i++)
-		hw->mac.addr[i] = hw->mac.perm_addr[i];
+	memcpy(hw->mac.addr, hw->mac.perm_addr, ETH_ALEN);
 
 	return E1000_SUCCESS;
 }
-- 
1.7.8.111.gad25c.dirty

