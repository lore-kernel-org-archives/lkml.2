Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab2JOKdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 06:33:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57364 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2JOKdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 06:33:47 -0400
From: Chad Williamson <chad@dahc.us>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Daniel Cotey <puff65537@bansheeslibrary.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 5/5] staging: silicom: fix explicit intialization of procfs_dir in bp_proc.c
Date: Mon, 15 Oct 2012 05:30:39 -0500
Message-Id: <1350297039-8166-6-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350297039-8166-1-git-send-email-chad@dahc.us>
References: <1350297039-8166-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove explicit intialization of static procfs_dir to NULL, resolving a
checkpatch.pl error.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bp_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/silicom/bp_proc.c b/drivers/staging/silicom/bp_proc.c
index 0f110aa..37f998c 100644
--- a/drivers/staging/silicom/bp_proc.c
+++ b/drivers/staging/silicom/bp_proc.c
@@ -1130,7 +1130,7 @@ set_hw_reset_pfs(struct file *file, const char *buffer,
 int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
 {
 	struct bypass_pfs_sd *current_pfs = &(pbp_device_block->bypass_pfs_set);
-	static struct proc_dir_entry *procfs_dir = NULL;
+	static struct proc_dir_entry *procfs_dir;
 	int ret = 0;
 
 	sprintf(current_pfs->dir_name, "bypass_%s", dev->name);
-- 
1.7.12.2

