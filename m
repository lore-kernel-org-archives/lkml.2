Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab1DZTp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:45:59 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60931 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1DZTp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 15:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UxAs14mIuZWh7/zMUqXqL/mf0p7Z7GJhQbWpVPMjixm8T9/9sLQasF+O/0tvKsg5kT
         AqG9zZh44hMZGvnk1FSCemFxsDtHEb47oaarXimoZ8p1evBcSeuVl1kJKHqXYMPRZ5a2
         GecurpAFejgodFYJtFfC5wfrElVOwCVOYsPDg=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] linux/string.h: Introduce streq macro.
Date: Tue, 26 Apr 2011 16:45:36 -0300
Message-Id: <e8a554f881a199107afd37795adb0d11e70fdbcc.1303846852.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.5.g60e19
In-Reply-To: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is arguably more readable than its variants:
- !strcmp(a, b)
- strcmp(a, b) == 0

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 Changes from v1 (Steven and Alexey review):
 - Convert from macro to static inline.
 - Remove the example.
 - Add the suggested comment by Steven.

 include/linux/string.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..d859bb2 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -134,6 +134,21 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
 /**
+ * streq - Are two strings equal?
+ * @a: first string
+ * @b: second string
+ *
+ * Use: streq(a, b)
+ * Instead of: strcmp(a, b) == 0 or !strcmp(a, b)
+ *
+ * This makes the code more readable and less error prone.
+ */
+static inline int streq(const char *a, const char *b)
+{
+	return strcmp(a, b) == 0;
+}
+
+/**
  * strstarts - does @str start with @prefix?
  * @str: string to examine
  * @prefix: prefix to look for.
-- 
1.7.5.rc2.5.g60e19

