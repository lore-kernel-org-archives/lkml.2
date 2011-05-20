Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840Ab1ETALx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58239 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934715Ab1ETALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:47 -0400
X-Sasl-enc: HcIxZSJF7yzSBoE6+TbtEHpovbtnHVtmWFOTgODFTUyy 1305850306
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 24/44] Add a strtobool function matching semantics of existing in kernel equivalents
Date: Thu, 19 May 2011 17:10:42 -0700
Message-Id: <1305850262-9575-24-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

This is a rename of the usr_strtobool proposal, which was a renamed,
relocated and fixed version of previous kstrtobool RFC

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.4.2

