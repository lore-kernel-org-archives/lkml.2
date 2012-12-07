Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423637Ab2LGBAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:00:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423581Ab2LGBAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 20:00:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ariel Elior <ariele@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>, CAI Qian <caiqian@redhat.com>
Subject: [ 18/27] bnx2x: remove redundant warning log
Date: Thu,  6 Dec 2012 16:59:02 -0800
Message-Id: <20121207005831.101223486@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Elior <ariele@broadcom.com>

commit 4a25417c20fac00b3afd58ce27408f964d19e708 upstream.

fix bug where a register which was only meant to be read in 578xx/57712
devices causes a bogus error message to be logged when read from other
devices.

Signed-off-by: Ariel Elior <ariele@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -9545,10 +9545,13 @@ static int __devinit bnx2x_prev_unload_c
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
 


