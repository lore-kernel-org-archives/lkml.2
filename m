Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1DSLlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:41:52 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:47822 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1DSLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:41:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, greg@kroah.com, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/3] debugfs: move to new strtobool
Date: Tue, 19 Apr 2011 12:43:46 +0100
Message-Id: <1303213427-12798-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <a>
References: <a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes requires that we eat errors from strtobool.
If people want to not do this, then it should be fixed at a later date.

V2: Simplification suggested by Rusty Russell removes the need for
additional variable ret.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
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
1.7.3.4

