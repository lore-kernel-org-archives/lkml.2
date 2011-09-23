Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1IWUrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:47:07 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:46126 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1IWUrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:47:05 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-132.messagelabs.com!1316810822!39614100!5
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] exofs/super.c: local functions should be static
Date: Fri, 23 Sep 2011 13:46:51 -0700
User-Agent: KMail/1.9.9
CC: <osd-dev@open-osd.org>, <bharrosh@panasas.com>, <bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109231346.51759.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This quiets the following sparse noise:

warning: symbol 'exofs_sync_fs' was not declared. Should it be static?
warning: symbol 'exofs_free_sbi' was not declared. Should it be static?
warning: symbol 'exofs_get_parent' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>

---

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 9049e27..8c900d4 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -356,7 +356,7 @@ static const struct export_operations exofs_export_ops;
 /*
  * Write the superblock to the OSD
  */
-int exofs_sync_fs(struct super_block *sb, int wait)
+static int exofs_sync_fs(struct super_block *sb, int wait)
 {
 	struct exofs_sb_info *sbi;
 	struct exofs_fscb *fscb;
@@ -430,7 +430,7 @@ static void _exofs_print_device(const char *msg, const char *dev_path,
 		msg, dev_path ?: "", odi->osdname, _LLU(pid));
 }
 
-void exofs_free_sbi(struct exofs_sb_info *sbi)
+static void exofs_free_sbi(struct exofs_sb_info *sbi)
 {
 	while (sbi->comps.numdevs) {
 		int i = --sbi->comps.numdevs;
@@ -969,7 +969,7 @@ static const struct super_operations exofs_sops = {
  * EXPORT OPERATIONS
  *****************************************************************************/
 
-struct dentry *exofs_get_parent(struct dentry *child)
+static struct dentry *exofs_get_parent(struct dentry *child)
 {
 	unsigned long ino = exofs_parent_ino(child);
 
