Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2LVVQI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 16:16:08 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:35654 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 16:16:05 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@lst.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] target: initialize sense_reason_t ret in core_scsi3_emulate_pro_register()
Date: Sat, 22 Dec 2012 22:15:57 +0100
Message-Id: <1356210957-30089-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/target/target_core_pr.c: In function ‘core_scsi3_emulate_pro_register’:
drivers/target/target_core_pr.c:2056: warning: ‘ret’ may be used uninitialized in this function

If !spec_i_pt, the "goto out_put_pr_reg" on line 2141 seems to be a real
case where ret is not initialized.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/target/target_core_pr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e35dbf8..c2e8026 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2053,7 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	/* Used for APTPL metadata w/ UNREGISTER */
 	unsigned char *pr_aptpl_buf = NULL;
 	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
-	sense_reason_t ret;
+	sense_reason_t ret = 0;
 	int pr_holder = 0, type;
 
 	if (!se_sess || !se_lun) {
-- 
1.7.0.4

