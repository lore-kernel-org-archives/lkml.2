Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab1BPJO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 04:14:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312Ab1BPJOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 04:14:54 -0500
From: Michal Marek <mmarek@suse.cz>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        matt mooney <mfm@muteddisk.com>
Subject: [PATCH] ntfs: Makefile cleanup
Date: Wed, 16 Feb 2011 10:13:29 +0100
Message-Id: <1297847609-2903-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Replace EXTRA_CFLAGS with ccflags-y. And change ntfs-objs to ntfs-y
for cleaner conditional inclusion.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 fs/ntfs/Makefile |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/ntfs/Makefile b/fs/ntfs/Makefile
index 4ff028f..30206b2 100644
--- a/fs/ntfs/Makefile
+++ b/fs/ntfs/Makefile
@@ -2,18 +2,13 @@
 
 obj-$(CONFIG_NTFS_FS) += ntfs.o
 
-ntfs-objs := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
-	     index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
-	     unistr.o upcase.o
+ntfs-y := aops.o attrib.o collate.o compress.o debug.o dir.o file.o \
+	  index.o inode.o mft.o mst.o namei.o runlist.o super.o sysctl.o \
+	  unistr.o upcase.o
 
-EXTRA_CFLAGS = -DNTFS_VERSION=\"2.1.30\"
+ntfs-$(CONFIG_NTFS_RW) += bitmap.o lcnalloc.o logfile.o quota.o usnjrnl.o
 
-ifeq ($(CONFIG_NTFS_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-y := -DNTFS_VERSION=\"2.1.30\"
+ccflags-$(CONFIG_NTFS_DEBUG)	+= -DDEBUG
+ccflags-$(CONFIG_NTFS_RW)	+= -DNTFS_RW
 
-ifeq ($(CONFIG_NTFS_RW),y)
-EXTRA_CFLAGS += -DNTFS_RW
-
-ntfs-objs += bitmap.o lcnalloc.o logfile.o quota.o usnjrnl.o
-endif
-- 
1.7.3.4

