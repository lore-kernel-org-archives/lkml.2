Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab1CWNiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:38:08 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:57164 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab1CWNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:38:04 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/3] params.c: Use new kstrtobool implementation to processing boolean inputs.
Date: Wed, 23 Mar 2011 13:39:14 +0000
Message-Id: <1300887554-19031-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 kernel/params.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 0da1411..37b4d83 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -297,3 +297,4 @@ EXPORT_SYMBOL(param_ops_charp);
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
+	ret = kstrtobool(val, &v);
+	if (ret)
+		return ret;
 
 	if (kp->flags & KPARAM_ISBOOL)
 		*(bool *)kp->arg = v;
-- 
1.7.3.4

