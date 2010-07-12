Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0GLUuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab0GLUuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/36] drivers/char: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:58 -0700
Message-Id: <6dda15a1068a962e4167c3811079be2647ed178a.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/snsc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/snsc.c b/drivers/char/snsc.c
index 32b74de..ae6aa91 100644
--- a/drivers/char/snsc.c
+++ b/drivers/char/snsc.c
@@ -129,7 +129,7 @@ scdrv_open(struct inode *inode, struct file *file)
 static int
 scdrv_release(struct inode *inode, struct file *file)
 {
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 	int rv;
 
 	/* free the interrupt */
@@ -161,7 +161,7 @@ scdrv_read(struct file *file, char __user *buf, size_t count, loff_t *f_pos)
 	int status;
 	int len;
 	unsigned long flags;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 
 	/* try to get control of the read buffer */
 	if (down_trylock(&sd->sd_rbs)) {
@@ -253,7 +253,7 @@ scdrv_write(struct file *file, const char __user *buf,
 {
 	unsigned long flags;
 	int status;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 
 	/* try to get control of the write buffer */
 	if (down_trylock(&sd->sd_wbs)) {
@@ -326,7 +326,7 @@ scdrv_poll(struct file *file, struct poll_table_struct *wait)
 {
 	unsigned int mask = 0;
 	int status = 0;
-	struct subch_data_s *sd = (struct subch_data_s *) file->private_data;
+	struct subch_data_s *sd = file->private_data;
 	unsigned long flags;
 
 	poll_wait(file, &sd->sd_rq, wait);
-- 
1.7.1.337.g6068.dirty

