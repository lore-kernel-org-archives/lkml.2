Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab1CXNWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:22:32 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33511 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab1CXNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:22:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/3] debugfs: move to new usr_strtobool
Date: Thu, 24 Mar 2011 13:23:44 +0000
Message-Id: <1300973025-32497-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional chagnes requires that we eat errors from usr_strtobool.
If people want to not do this, then it should be at a later date.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 fs/debugfs/file.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 89d394d..1f0e3ef 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -428,26 +428,18 @@ static ssize_t write_file_bool(struct file *file, const char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	char buf[32];
-	int buf_size;
+	int buf_size, ret;
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
+	ret = usr_strtobool(buf, &bv);
+	if (!ret)
+		*val = bv;
+
 	return count;
 }
 
-- 
1.7.3.4

