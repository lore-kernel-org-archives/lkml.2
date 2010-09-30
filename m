Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab0I3LAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 07:00:48 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41646 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0I3LAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 07:00:46 -0400
From: Borislav Petkov <bp@amd64.org>
To: <norsk5@yahoo.com>
Cc: <linux-edac@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/8] EDAC, MCE: Remove unused function parameter
Date: Thu, 30 Sep 2010 13:01:44 +0200
Message-Id: <1285844509-27120-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285844509-27120-1-git-send-email-bp@amd64.org>
References: <1285844509-27120-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Remove remains from previous functionality.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac_dbg.c |    2 +-
 drivers/edac/edac_mce_amd.c   |    7 ++-----
 drivers/edac/edac_mce_amd.h   |    2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/amd64_edac_dbg.c b/drivers/edac/amd64_edac_dbg.c
index 59cf2cf..22ef3fe 100644
--- a/drivers/edac/amd64_edac_dbg.c
+++ b/drivers/edac/amd64_edac_dbg.c
@@ -24,7 +24,7 @@ static ssize_t amd64_nbea_store(struct mem_ctl_info *mci, const char *data,
 
 		/* Process the Mapping request */
 		/* TODO: Add race prevention */
-		amd_decode_nb_mce(pvt->mc_node_id, &pvt->ctl_error_info, 1);
+		amd_decode_nb_mce(pvt->mc_node_id, &pvt->ctl_error_info);
 
 		return count;
 	}
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 564fe7c..765d7fb 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -291,13 +291,10 @@ wrong_ls_mce:
 	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
 }
 
-void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
+void amd_decode_nb_mce(int node_id, struct err_regs *regs)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
 
-	if (!handle_errors)
-		return;
-
 	/*
 	 * GART TLB error reporting is disabled by default. Bail out early.
 	 */
@@ -402,7 +399,7 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 		regs.nbeah = (u32)(m->addr >> 32);
 		node       = amd_get_nb_id(m->extcpu);
 
-		amd_decode_nb_mce(node, &regs, 1);
+		amd_decode_nb_mce(node, &regs);
 		break;
 
 	case 5:
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index df23ee0..8920133 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -64,6 +64,6 @@ struct err_regs {
 void amd_report_gart_errors(bool);
 void amd_register_ecc_decoder(void (*f)(int, struct err_regs *));
 void amd_unregister_ecc_decoder(void (*f)(int, struct err_regs *));
-void amd_decode_nb_mce(int, struct err_regs *, int);
+void amd_decode_nb_mce(int, struct err_regs *);
 
 #endif /* _EDAC_MCE_AMD_H */
-- 
1.7.1

