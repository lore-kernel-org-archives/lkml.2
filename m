Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab0DLQkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:40:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:60923 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0DLQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:40:22 -0400
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH] JFS: Free sbi memory in error path
Date: Mon, 12 Apr 2010 18:40:17 +0200
Message-Id: <1271090417-19408-1-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spotted the missing kfree() while removing the BKL.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/jfs/super.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/jfs/super.c b/fs/jfs/super.c
index 266699d..a402b7d 100644
--- a/fs/jfs/super.c
+++ b/fs/jfs/super.c
@@ -457,6 +457,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (newLVSize) {
 		printk(KERN_ERR "resize option for remount only\n");
+		kfree(sbi);
 		return -EINVAL;
 	}
 
-- 
1.6.4.2

