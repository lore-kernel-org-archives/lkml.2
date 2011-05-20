Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859Ab1ETAL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:57 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42784 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756038Ab1ETALt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:49 -0400
X-Sasl-enc: ySzdFXQ8dj5/spQO8yqxdLMvx1LHGo+NvaoevCflsBAW 1305850308
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/44] debugfs: move to new strtobool
Date: Thu, 19 May 2011 17:10:43 -0700
Message-Id: <1305850262-9575-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

No functional changes requires that we eat errors from strtobool.
If people want to not do this, then it should be fixed at a later date.

V2: Simplification suggested by Rusty Russell removes the need for
additional variable ret.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 89d394d..568304d 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -429,25 +429,16 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 {
 	char buf[32];
 	int buf_size;
+	bool bv;
 	u32 *val = file->private_data;
 
 	buf_size = min(count, (sizeof(buf)-1));
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
 
-	switch (buf[0]) {
-	case 'y':
-	case 'Y':
-	case '1':
-		*val = 1;
-		break;
-	case 'n':
-	case 'N':
-	case '0':
-		*val = 0;
-		break;
-	}
-	
+	if (strtobool(buf, &bv) == 0)
+		*val = bv;
+
 	return count;
 }
 
-- 
1.7.4.2

