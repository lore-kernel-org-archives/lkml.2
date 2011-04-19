Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907Ab1DSLlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:41:53 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:47820 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1DSLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:41:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, greg@kroah.com, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 3/3] params.c: Use new strtobool function to process boolean inputs
Date: Tue, 19 Apr 2011 12:43:47 +0100
Message-Id: <1303213427-12798-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <a>
References: <a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 kernel/params.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 7ab388a..6888761 100644
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
+	ret = strtobool(val, &v);
+	if (ret)
+		return ret;
 
 	if (kp->flags & KPARAM_ISBOOL)
 		*(bool *)kp->arg = v;
-- 
1.7.3.4

