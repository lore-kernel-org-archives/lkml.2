Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347Ab2CMAkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:40:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:48543 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074Ab2CMAYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:24:14 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 152/196] e1000e: Reset 82577/82578 PHY before first PHY register read
Date: Mon, 12 Mar 2012 20:21:05 -0400
Message-Id: <1331598109-31424-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 627c8a041f7aaaea93c766f69bd61d952a277586 upstream.

Reset the PHY before first accessing it.  Doing so, ensure that the PHY is
in a known good state before we read/write PHY registers. This fixes a
driver probe failure.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/e1000e/ich8lan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 8b5e157..a626012 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -274,6 +274,16 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 	phy->ops.power_down           = e1000_power_down_phy_copper_ich8lan;
 	phy->autoneg_mask             = AUTONEG_ADVERTISE_SPEED_DEFAULT;
 
+	/*
+	 * Reset the PHY before any acccess to it.  Doing so, ensures that
+	 * the PHY is in a known good state before we read/write PHY registers.
+	 * The generic reset is sufficient here, because we haven't determined
+	 * the PHY type yet.
+	 */
+	ret_val = e1000e_phy_hw_reset_generic(hw);
+	if (ret_val)
+		goto out;
+
 	phy->id = e1000_phy_unknown;
 	ret_val = e1000e_get_phy_id(hw);
 	if (ret_val)
-- 
1.7.9.3

