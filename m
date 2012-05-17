Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761733Ab2EQMsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 08:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760912Ab2EQMs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 08:48:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/24] GFS2: Rename function gfs2_close to gfs2_release
Date: Thu, 17 May 2012 13:23:10 +0100
Message-Id: <1337257411-3173-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
References: <1337257411-3173-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch renames function gfs2_close to gfs2_release.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index a3d2c9e..31b199f 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -558,14 +558,14 @@ fail:
 }
 
 /**
- * gfs2_close - called to close a struct file
+ * gfs2_release - called to close a struct file
  * @inode: the inode the struct file belongs to
  * @file: the struct file being closed
  *
  * Returns: errno
  */
 
-static int gfs2_close(struct inode *inode, struct file *file)
+static int gfs2_release(struct inode *inode, struct file *file)
 {
 	struct gfs2_sbd *sdp = inode->i_sb->s_fs_info;
 	struct gfs2_file *fp;
@@ -1005,7 +1005,7 @@ const struct file_operations gfs2_file_fops = {
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
-	.release	= gfs2_close,
+	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
@@ -1019,7 +1019,7 @@ const struct file_operations gfs2_dir_fops = {
 	.readdir	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
-	.release	= gfs2_close,
+	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
 	.lock		= gfs2_lock,
 	.flock		= gfs2_flock,
@@ -1037,7 +1037,7 @@ const struct file_operations gfs2_file_fops_nolock = {
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
-	.release	= gfs2_close,
+	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= generic_file_splice_write,
@@ -1049,7 +1049,7 @@ const struct file_operations gfs2_dir_fops_nolock = {
 	.readdir	= gfs2_readdir,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.open		= gfs2_open,
-	.release	= gfs2_close,
+	.release	= gfs2_release,
 	.fsync		= gfs2_fsync,
 	.llseek		= default_llseek,
 };
-- 
1.7.4

