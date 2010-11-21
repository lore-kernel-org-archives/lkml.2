Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0KUCva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:51:30 -0500
Received: from mail.perches.com ([173.55.12.10]:1668 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756481Ab0KUCkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:03 -0500
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 23/62] igb: Use static const
Date: Sat, 20 Nov 2010 18:38:24 -0800
Message-Id: <3c7a9986975c9eb2676f336d1be8bc5f00d3dd1c.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  25448	   1280	   6176	  32904	   8088	drivers/net/igb/e1000_phy.o.new
  25462	   1280	   6176	  32918	   8096	drivers/net/igb/e1000_phy.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/igb/e1000_phy.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/igb/e1000_phy.c b/drivers/net/igb/e1000_phy.c
index ddd036a..2dc089e 100644
--- a/drivers/net/igb/e1000_phy.c
+++ b/drivers/net/igb/e1000_phy.c
@@ -1757,11 +1757,12 @@ s32 igb_get_cable_length_igp_2(struct e1000_hw *hw)
 	u16 phy_data, i, agc_value = 0;
 	u16 cur_agc_index, max_agc_index = 0;
 	u16 min_agc_index = IGP02E1000_CABLE_LENGTH_TABLE_SIZE - 1;
-	u16 agc_reg_array[IGP02E1000_PHY_CHANNEL_NUM] =
-							 {IGP02E1000_PHY_AGC_A,
-							  IGP02E1000_PHY_AGC_B,
-							  IGP02E1000_PHY_AGC_C,
-							  IGP02E1000_PHY_AGC_D};
+	static const u16 agc_reg_array[IGP02E1000_PHY_CHANNEL_NUM] = {
+		IGP02E1000_PHY_AGC_A,
+		IGP02E1000_PHY_AGC_B,
+		IGP02E1000_PHY_AGC_C,
+		IGP02E1000_PHY_AGC_D
+	};
 
 	/* Read the AGC registers for all channels */
 	for (i = 0; i < IGP02E1000_PHY_CHANNEL_NUM; i++) {
-- 
1.7.3.2.245.g03276.dirty

