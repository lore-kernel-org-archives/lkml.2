Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0H1Plu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:41:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42052 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0H1PlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:41:19 -0400
From: Julia Lawall <julia@diku.dk>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] drivers/net/atl1c: Remove double test
Date: Sat, 28 Aug 2010 17:41:02 +0200
Message-Id: <1283010066-20935-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283010066-20935-1-git-send-email-julia@diku.dk>
References: <1283010066-20935-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nic_type field is compared to athr_l2c twice.

The sematic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression E;
@@

(
* E
  || ... || E
|
* E
  && ... && E
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This is a guess as to what the code should be.  Perhaps something else
should have been tested instead.

 drivers/net/atl1c/atl1c_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/atl1c/atl1c_hw.c b/drivers/net/atl1c/atl1c_hw.c
index d8501f0..919080b 100644
--- a/drivers/net/atl1c/atl1c_hw.c
+++ b/drivers/net/atl1c/atl1c_hw.c
@@ -480,7 +480,7 @@ int atl1c_phy_reset(struct atl1c_hw *hw)
 		atl1c_write_phy_reg(hw, MII_DBG_DATA, 0x929D);
 	}
 	if (hw->nic_type == athr_l1c || hw->nic_type == athr_l2c_b2
-		|| hw->nic_type == athr_l2c || hw->nic_type == athr_l2c) {
+		|| hw->nic_type == athr_l2c) {
 		atl1c_write_phy_reg(hw, MII_DBG_ADDR, 0x29);
 		atl1c_write_phy_reg(hw, MII_DBG_DATA, 0xB6DD);
 	}

