Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab1I1Wuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab1I1Wum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.894662744@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dmitry Kravkov <dmitry@broadcom.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [242/244] bnx2x: fix hw attention handling
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitry Kravkov <dmitry@broadcom.com>

commit f2eaeb58bf6995a979c413ea0cc73289533feacb upstream.

Use register name to initialize attention mask

Signed-off-by: Dmitry Kravkov <dmitry@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/bnx2x/bnx2x_main.c |    6 ++++--
 drivers/net/bnx2x/bnx2x_reg.h  |   12 ++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -4138,7 +4138,7 @@ static void bnx2x_init_def_sb(struct bnx
 	int igu_seg_id;
 	int port = BP_PORT(bp);
 	int func = BP_FUNC(bp);
-	int reg_offset;
+	int reg_offset, reg_offset_en5;
 	u64 section;
 	int index;
 	struct hc_sp_status_block_data sp_sb_data;
@@ -4161,6 +4161,8 @@ static void bnx2x_init_def_sb(struct bnx
 
 	reg_offset = (port ? MISC_REG_AEU_ENABLE1_FUNC_1_OUT_0 :
 			     MISC_REG_AEU_ENABLE1_FUNC_0_OUT_0);
+	reg_offset_en5 = (port ? MISC_REG_AEU_ENABLE5_FUNC_1_OUT_0 :
+				 MISC_REG_AEU_ENABLE5_FUNC_0_OUT_0);
 	for (index = 0; index < MAX_DYNAMIC_ATTN_GRPS; index++) {
 		int sindex;
 		/* take care of sig[0]..sig[4] */
@@ -4175,7 +4177,7 @@ static void bnx2x_init_def_sb(struct bnx
 			 * and not 16 between the different groups
 			 */
 			bp->attn_group[index].sig[4] = REG_RD(bp,
-					reg_offset + 0x10 + 0x4*index);
+					reg_offset_en5 + 0x4*index);
 		else
 			bp->attn_group[index].sig[4] = 0;
 	}
--- a/drivers/net/bnx2x/bnx2x_reg.h
+++ b/drivers/net/bnx2x/bnx2x_reg.h
@@ -1325,6 +1325,18 @@
    Latched ump_tx_parity; [31] MCP Latched scpad_parity; */
 #define MISC_REG_AEU_ENABLE4_PXP_0				 0xa108
 #define MISC_REG_AEU_ENABLE4_PXP_1				 0xa1a8
+/* [RW 32] fifth 32b for enabling the output for function 0 output0. Mapped
+ * as follows: [0] PGLUE config_space; [1] PGLUE misc_flr; [2] PGLUE B RBC
+ * attention [3] PGLUE B RBC parity; [4] ATC attention; [5] ATC parity; [6]
+ * mstat0 attention; [7] mstat0 parity; [8] mstat1 attention; [9] mstat1
+ * parity; [31-10] Reserved; */
+#define MISC_REG_AEU_ENABLE5_FUNC_0_OUT_0			 0xa688
+/* [RW 32] Fifth 32b for enabling the output for function 1 output0. Mapped
+ * as follows: [0] PGLUE config_space; [1] PGLUE misc_flr; [2] PGLUE B RBC
+ * attention [3] PGLUE B RBC parity; [4] ATC attention; [5] ATC parity; [6]
+ * mstat0 attention; [7] mstat0 parity; [8] mstat1 attention; [9] mstat1
+ * parity; [31-10] Reserved; */
+#define MISC_REG_AEU_ENABLE5_FUNC_1_OUT_0			 0xa6b0
 /* [RW 1] set/clr general attention 0; this will set/clr bit 94 in the aeu
    128 bit vector */
 #define MISC_REG_AEU_GENERAL_ATTN_0				 0xa000


