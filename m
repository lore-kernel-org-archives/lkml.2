Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab1CXNWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:22:33 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33508 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892Ab1CXNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:22:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/3] params.c: Use new usr_strtobool function to process boolean inputs
Date: Thu, 24 Mar 2011 13:23:45 +0000
Message-Id: <1300973025-32497-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 kernel/params.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0da1411..49d15fe 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -297,21 +297,15 @@ EXPORT_SYMBOL(param_ops_charp);
 int param_set_bool(const char *val, const struct kernel_param *kp)
 {
 	bool v;
+	int ret;
 
 	/* No equals means "set"... */
 	if (!val) val = "1";
 
 	/* One of =[yYnN01] */
-	switch (val[0]) {
-	case 'y': case 'Y': case '1':
-		v = true;
-		break;
-	case 'n': case 'N': case '0':
-		v = false;
-		break;
-	default:
-		return -EINVAL;
-	}
+	ret = usr_strtobool(val, &v);
+	if (ret)
+		return ret;
 
 	if (kp->flags & KPARAM_ISBOOL)
 		*(bool *)kp->arg = v;
-- 
1.7.3.4

