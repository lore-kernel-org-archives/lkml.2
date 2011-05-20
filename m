Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab1ETAQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:16:37 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43172 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934790Ab1ETALu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:50 -0400
X-Sasl-enc: Nx4mK0e+np9B3VUwzuGC7x7cCCvZj6v6IPCo1X57UR4J 1305850309
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/44] params.c: Use new strtobool function to process boolean inputs
Date: Thu, 19 May 2011 17:10:44 -0700
Message-Id: <1305850262-9575-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

No functional changes.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.4.2

