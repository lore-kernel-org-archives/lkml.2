Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1CVJl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:41:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:10604 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab1CVJlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:41:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="669853690"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] proc/stat: use defined macro KMALLOC_MAX_SIZE
Date: Tue, 22 Mar 2011 17:41:07 +0800
Message-Id: <1300786867-8355-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a macro for the max size kmalloc can allocate, so use it
instead of a hardcoded number.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 fs/proc/stat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 1cffa2b..9758b65 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -138,9 +138,9 @@ static int stat_open(struct inode *inode, struct file *file)
 	struct seq_file *m;
 	int res;
 
-	/* don't ask for more than the kmalloc() max size, currently 128 KB */
-	if (size > 128 * 1024)
-		size = 128 * 1024;
+	/* don't ask for more than the kmalloc() max size */
+	if (size > KMALLOC_MAX_SIZE)
+		size = KMALLOC_MAX_SIZE;
 	buf = kmalloc(size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
-- 
1.7.4

