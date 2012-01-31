Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2AaIxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 03:53:21 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:35352 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab2AaIxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 03:53:19 -0500
Date: Tue, 31 Jan 2012 11:53:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] HPFS: remove PRINTK() macro
Message-ID: <20120131085313.GC22039@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F27ABF6.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PRINTK() macro isn't really used.  Let's just remove it because it
is ugly and out of date.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/hpfs/buffer.c b/fs/hpfs/buffer.c
index 9ecde27..f49d149 100644
--- a/fs/hpfs/buffer.c
+++ b/fs/hpfs/buffer.c
@@ -156,7 +156,6 @@ void hpfs_brelse4(struct quad_buffer_head *qbh)
 
 void hpfs_mark_4buffers_dirty(struct quad_buffer_head *qbh)
 {
-	PRINTK(("hpfs_mark_4buffers_dirty\n"));
 	memcpy(qbh->bh[0]->b_data, qbh->data, 512);
 	memcpy(qbh->bh[1]->b_data, qbh->data + 512, 512);
 	memcpy(qbh->bh[2]->b_data, qbh->data + 2 * 512, 512);
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index de94617..6d2d500 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -35,13 +35,6 @@
 
 #define CHKCOND(x,y) if (!(x)) printk y
 
-#ifdef DBG
-#define PRINTK(x) printk x
-#else
-#undef PRINTK
-#define PRINTK(x)
-#endif
-
 struct hpfs_inode_info {
 	loff_t mmu_private;
 	ino_t i_parent_dir;	/* (directories) gives fnode of parent dir */
