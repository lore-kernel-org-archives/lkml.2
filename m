Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab1AMMlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:41:12 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47063 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab1AMMlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:41:09 -0500
From: Simon Xu <xu.simon@oracle.com>
To: jack@suse.cz
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Xu <xu.simon@oracle.com>
Subject: [PATCH] ext2: reduce redundant check of '*options'
Date: Thu, 13 Jan 2011 20:39:22 +0800
Message-Id: <1294922362-2237-1-git-send-email-xu.simon@oracle.com>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to check whether '*options' equals to ',' twice.

Signed-off-by: Simon Xu <xu.simon@oracle.com>
---
 fs/ext2/super.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7731695..bd5b66b 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -377,13 +377,13 @@ static unsigned long get_sb_block(void **data)
 		return 1;	/* Default location */
 	options += 3;
 	sb_block = simple_strtoul(options, &options, 0);
-	if (*options && *options != ',') {
+	if (*options == ',') {
+		options++;
+	} else if (*options) {
 		printk("EXT2-fs: Invalid sb specification: %s\n",
 		       (char *) *data);
 		return 1;
 	}
-	if (*options == ',')
-		options++;
 	*data = (void *) options;
 	return sb_block;
 }
-- 
1.7.3.5

