Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1BNQjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:39:31 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:52989 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755558Ab1BNQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:39:29 -0500
Subject: fs: remove 8 bytes of padding from block_device on 64bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 16:39:26 +0000
Message-ID: <1297701566.2014.6.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-ordering struct block_inode to remove 8 bytes of padding on 64 bit
builds, which also shrinks bdev_inode by 8 bytes (776 -> 768) allowing
it to fit into one fewer cache lines.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
------
patch against v2.6.38-rc4
compiled & tested on x86_64

regards
Richard



diff --git a/include/linux/fs.h b/include/linux/fs.h
index bd32159..7c65780 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -658,9 +658,9 @@ struct address_space {
 
 struct block_device {
 	dev_t			bd_dev;  /* not a kdev_t - it's a search key */
+	int			bd_openers;
 	struct inode *		bd_inode;	/* will die */
 	struct super_block *	bd_super;
-	int			bd_openers;
 	struct mutex		bd_mutex;	/* open/close mutex */
 	struct list_head	bd_inodes;
 	void *			bd_claiming;


