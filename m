Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501Ab2LMOPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:15:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45139 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933308Ab2LMOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:15:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ariel Elior <ariele@broadcom.com>, Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 229/241] bnx2x: remove redundant warning log
Date: Thu, 13 Dec 2012 11:59:54 -0200
Message-Id: <1355407206-17100-230-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Elior <ariele@broadcom.com>

commit 4a25417c20fac00b3afd58ce27408f964d19e708 upstream.

fix bug where a register which was only meant to be read in 578xx/57712
devices causes a bogus error message to be logged when read from other
devices.

Signed-off-by: Ariel Elior <ariele@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index f755a66..b398a1a 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9494,10 +9494,13 @@ static int __devinit bnx2x_prev_unload_common(struct bnx2x *bp)
  */
 static void __devinit bnx2x_prev_interrupted_dmae(struct bnx2x *bp)
 {
-	u32 val = REG_RD(bp, PGLUE_B_REG_PGLUE_B_INT_STS);
-	if (val & PGLUE_B_PGLUE_B_INT_STS_REG_WAS_ERROR_ATTN) {
-		BNX2X_ERR("was error bit was found to be set in pglueb upon startup. Clearing");
-		REG_WR(bp, PGLUE_B_REG_WAS_ERROR_PF_7_0_CLR, 1 << BP_FUNC(bp));
+	if (!CHIP_IS_E1x(bp)) {
+		u32 val = REG_RD(bp, PGLUE_B_REG_PGLUE_B_INT_STS);
+		if (val & PGLUE_B_PGLUE_B_INT_STS_REG_WAS_ERROR_ATTN) {
+			BNX2X_ERR("was error bit was found to be set in pglueb upon startup. Clearing");
+			REG_WR(bp, PGLUE_B_REG_WAS_ERROR_PF_7_0_CLR,
+			       1 << BP_FUNC(bp));
+		}
 	}
 }
 
-- 
1.7.9.5

