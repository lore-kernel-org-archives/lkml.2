Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0F2KT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:19:59 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0F2KPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nvEEPrm62yv+IhI45iE2J3NUwNPHFMkinjkSnDOkHEL555a2UOUIyNfQS30WOfn1DY
         o+awog9tr36kyzokTOHlHlIz4LJRq9CFNjv6eDZRlIQcjOWkEUp6WeDxDzp1fYmwp+cB
         ePrYFODcqqiD/dGMkpmc6lR+MCkxt92wHku3M=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/25] snsc: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:05 +0400
Message-Id: <1277806506-30806-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
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
1.7.0.4

