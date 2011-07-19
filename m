Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab1GSBtn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:49:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab1GSBtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:49:42 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: hch@infradead.org
Cc: wanlong.gao@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew@wil.cx,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH] fs:update the NOTE of the file_operations structure
Date: Tue, 19 Jul 2011 09:48:39 +0800
Message-Id: <1311040119-5213-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-19 09:48:49,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-19 09:48:50,
	Serialize complete at 2011-07-19 09:48:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Big kernel lock had been removed and setlease now use the lock_flocks()
to hold a special spin lock file_lock_lock by Matthew.
So just remove the out-of-date NOTE.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 include/linux/fs.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b5b9792..67b2b21 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1538,11 +1538,6 @@ struct block_device_operations;
 #define HAVE_COMPAT_IOCTL 1
 #define HAVE_UNLOCKED_IOCTL 1
 
-/*
- * NOTE:
- * all file operations except setlease can be called without
- * the big kernel lock held in all filesystems.
- */
 struct file_operations {
 	struct module *owner;
 	loff_t (*llseek) (struct file *, loff_t, int);
-- 
1.7.6

