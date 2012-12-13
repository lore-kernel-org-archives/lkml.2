Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab2LMO0p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:26:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44915 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab2LMOM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:12:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mirko Lindner <mlindner@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 188/241] sky2: Fix for interrupt handler
Date: Thu, 13 Dec 2012 11:59:13 -0200
Message-Id: <1355407206-17100-189-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mirko Lindner <mlindner@marvell.com>

commit d663d181b9e92d80c2455e460e932d34e7a2a7ae upstream.

Re-enable interrupts if it is not our interrupt

Signed-off-by: Mirko Lindner <mlindner@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/marvell/sky2.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 28a5445..05c2cac 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3079,8 +3079,10 @@ static irqreturn_t sky2_intr(int irq, void *dev_id)
 
 	/* Reading this mask interrupts as side effect */
 	status = sky2_read32(hw, B0_Y2_SP_ISRC2);
-	if (status == 0 || status == ~0)
+	if (status == 0 || status == ~0) {
+		sky2_write32(hw, B0_Y2_SP_ICR, 2);
 		return IRQ_NONE;
+	}
 
 	prefetch(&hw->st_le[hw->st_idx]);
 
-- 
1.7.9.5

