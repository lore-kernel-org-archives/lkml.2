Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1CXNXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:23:05 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:33506 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab1CXNWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:22:31 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, rusty@rustcorp.com.au, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/3] Add a usr_strtobool function matching semantics of existing in kernel equivalents
Date: Thu, 24 Mar 2011 13:23:43 +0000
Message-Id: <1300973025-32497-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a renamed and relocated fixed version of previous kstrtobool RFC

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/string.h |    1 +
 lib/string.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..1977cc0 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -123,6 +123,7 @@ extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
+extern int usr_strtobool(const char *s, bool *res);
 
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
diff --git a/lib/string.c b/lib/string.c
index f71bead..121bd65 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -535,6 +535,35 @@ bool sysfs_streq(const char *s1, const char *s2)
 }
 EXPORT_SYMBOL(sysfs_streq);
 
+/**
+ * usr_strtobool - convert common user inputs into boolean values
+ * @s: input string
+ * @res: result
+ *
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
+ * Otherwise it will return -EINVAL.  Value pointed to by res is
+ * updated upon finding a match.
+ */
+int usr_strtobool(const char *s, bool *res)
+{
+	switch (s[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		*res = true;
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		*res = false;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(usr_strtobool);
+
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
-- 
1.7.3.4

