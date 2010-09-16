Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0IPRtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:49:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab0IPRqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:46:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jan Blunck <jblunck@infradead.org>
Subject: [PATCH 01/12] BKL: Remove BKL from usbfs
Date: Thu, 16 Sep 2010 19:46:14 +0200
Message-Id: <1284659185-8942-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284659185-8942-1-git-send-email-arnd@arndb.de>
References: <1284659185-8942-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:b/s3RfJuB/XjfNBO8GUeylPigb2yV+MOEjRnSITjUne
 3XkzM19Hjyxt7S/87yWGN125GOQ7MWhcfcTedeREfUv1flWXkH
 DzRicIjeE2LBxsk1DoO27XrU39EBx4BGdpbCeR2JD7WKOi3Fq8
 29avG8xLmaZCbG5JvzGFziPJChXCxFwuc88Ji30I4ITAaNf9JB
 Uo0vgZpykJdudaMVeZ/Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing in there has a race that can be
prevented by holding the BKL.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Jan Blunck <jblunck@infradead.org>
---
 drivers/usb/core/inode.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 73ec8c2..9e2ec9f 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -39,7 +39,6 @@
 #include <linux/parser.h>
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
-#include <linux/smp_lock.h>
 #include <linux/usb/hcd.h>
 #include <asm/byteorder.h>
 #include "usb.h"
@@ -457,8 +456,6 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 	struct inode *inode;
 	struct dentry *root;
 
-	lock_kernel();
-
 	sb->s_blocksize = PAGE_CACHE_SIZE;
 	sb->s_blocksize_bits = PAGE_CACHE_SHIFT;
 	sb->s_magic = USBDEVICE_SUPER_MAGIC;
@@ -468,7 +465,6 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!inode) {
 		dbg("%s: could not get inode!",__func__);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 
@@ -476,11 +472,9 @@ static int usbfs_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root) {
 		dbg("%s: could not get root dentry!",__func__);
 		iput(inode);
-		unlock_kernel();
 		return -ENOMEM;
 	}
 	sb->s_root = root;
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.7.1

