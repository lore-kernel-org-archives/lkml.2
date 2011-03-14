Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1CNLHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 07:07:40 -0400
Received: from nm19-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.59]:27744 "HELO
	nm19-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754150Ab1CNLHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 07:07:35 -0400
X-Yahoo-Newman-Id: 641909.73358.bm@omp1012.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: XWPZRVcVM1nABI61yiBA6LYdzUhS7kQ855_0k.JffMObUXW
 6I9MP0fYIcsGMWPHwwB4LVA_g5Tved9oD4D1yBYHU5SjzvD_mprK35baq7Mm
 TormwHjZu7kraKab4BO1wTjAXCGEyeSMl7HzBBQ4DsFxmT5QT_IFbUqLyf91
 duwZVEEWyIi4YUIpeY5ApE5qAMTZVOFTpqOfYZU5thnLt7zd3sFAdkJZOdWj
 bLX4Pkhhi0.OK.hwIEGhGx9.E3p9MYAWcezSehDT0nRlY_h.xbUtdDO71FR6
 dAaGDN_4GHDgfw9QO1oPJWrXJGUgMbYzbUHqmozwIeqwy4FLb1PaDanMKOQA
 TK1Q6TSgjx0UkdF6KaB1bAtUu1MZ_q04gZpQ0L8zSHkAE2.hIgNeiIXxWZo7
 w.Pb6bCksd3Vtl2U5qgp1jqkSgGovGAOlKtJjX.D5mga5Yh6MbTEW1bIXRdj
 rql0yk0z.u4Un1kkshducAN7rOofbj2UE
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>, Axel Lin <axel.lin@gmail.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 15/21] target: Add __init/__exit annotation for target_core_[init,exit]_configfs
Date: Mon, 14 Mar 2011 04:06:09 -0700
Message-Id: <1300100775-10012-16-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>

This patch fixes the follownig section mismatch warning:

WARNING: vmlinux.o(.text+0x21617a): Section mismatch in reference from the
function target_core_init_configfs() to the function .init.text:rd_module_init()

The function target_core_init_configfs() references the function __init
rd_module_init().  This is often because target_core_init_configfs() lacks
a __init annotation or the annotation of rd_module_init is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 9721ef2..a38fec4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3075,7 +3075,7 @@ static struct config_item_type target_core_cit = {
 
 /* Stop functions for struct config_item_type target_core_hba_cit */
 
-static int target_core_init_configfs(void)
+static int __init target_core_init_configfs(void)
 {
 	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
 	struct config_group *lu_gp_cg = NULL;
@@ -3207,7 +3207,7 @@ out_global:
 	return -1;
 }
 
-static void target_core_exit_configfs(void)
+static void __exit target_core_exit_configfs(void)
 {
 	struct configfs_subsystem *subsys;
 	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;
-- 
1.7.4.1

