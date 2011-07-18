Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1GRIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:25:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:5963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1GRIZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="28353891"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] selinuxfs: remove custome hex_to_bin()
Date: Mon, 18 Jul 2011 11:24:40 +0300
Message-Id: <db0926c83fcf7299ac345dc050c31ba3c26bf07c.1310977455.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: linux-security-module@vger.kernel.org
---
 security/selinux/selinuxfs.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 3545934..2aad7eb 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -752,14 +752,6 @@ out:
 	return length;
 }
 
-static inline int hexcode_to_int(int code) {
-	if (code == '\0' || !isxdigit(code))
-		return -1;
-	if (isdigit(code))
-		return code - '0';
-	return tolower(code) - 'a' + 10;
-}
-
 static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 {
 	char *scon = NULL, *tcon = NULL;
@@ -811,9 +803,11 @@ static ssize_t sel_write_create(struct file *file, char *buf, size_t size)
 			if (c1 == '+')
 				c1 = ' ';
 			else if (c1 == '%') {
-				if ((c1 = hexcode_to_int(*r++)) < 0)
+				c1 = hex_to_bin(*r++);
+				if (c1 < 0)
 					goto out;
-				if ((c2 = hexcode_to_int(*r++)) < 0)
+				c2 = hex_to_bin(*r++);
+				if (c2 < 0)
 					goto out;
 				c1 = (c1 << 4) | c2;
 			}
-- 
1.7.5.4

