Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1DSLly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:41:54 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:47818 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1DSLlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:41:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, greg@kroah.com, adobriyan@gmail.com,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 1/3] Add a strtobool function matching semantics of existing in kernel equivalents
Date: Tue, 19 Apr 2011 12:43:45 +0100
Message-Id: <1303213427-12798-2-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <a>
References: <a>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rename of the usr_strtobool proposal, which was a renamed,
relocated and fixed version of previous kstrtobool RFC

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 include/linux/string.h |    1 +
 lib/string.c           |   29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..a176db2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -123,6 +123,7 @@ extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
 extern void argv_free(char **argv);
 
 extern bool sysfs_streq(const char *s1, const char *s2);
+extern int strtobool(const char *s, bool *res);
 
 #ifdef CONFIG_BINARY_PRINTF
 int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
diff --git a/lib/string.c b/lib/string.c
index f71bead..01fad9b 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -535,6 +535,35 @@ bool sysfs_streq(const char *s1, const char *s2)
 }
 EXPORT_SYMBOL(sysfs_streq);
 
+/**
+ * strtobool - convert common user inputs into boolean values
+ * @s: input string
+ * @res: result
+ *
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
+ * Otherwise it will return -EINVAL.  Value pointed to by res is
+ * updated upon finding a match.
+ */
+int strtobool(const char *s, bool *res)
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
+EXPORT_SYMBOL(strtobool);
+
 #ifndef __HAVE_ARCH_MEMSET
 /**
  * memset - Fill a region of memory with the given value
-- 
1.7.3.4

