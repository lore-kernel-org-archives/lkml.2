Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab1DZSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:50:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64316 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab1DZSuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:50:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=whkcg/0GFNggr13pU8FPPkoXb4ndbbFLZftA/Oj3U3R2fkFtg20BXZg8pBKIoQ2RM5
         5JbRV8MZ+7MjbVrh5wT0d+ND8GOKCHOsnr2/YNJEp7ln3+C1q7iUjg89awMQfaesESkc
         vfqY5SYE8BAv06kY4CdFfpsYD1ixv/ZkRyou8=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] linux/string.h: Introduce streq macro.
Date: Tue, 26 Apr 2011 15:49:49 -0300
Message-Id: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.5.rc2.5.g60e19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is arguably more readable than its variants:
- !strcmp(a, b)
- strcmp(a, b) == 0

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 include/linux/string.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/string.h b/include/linux/string.h
index a716ee2..15b9602 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -134,6 +134,17 @@ extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
 			const void *from, size_t available);
 
 /**
+ * streq - Are two strings equal?
+ * @a: first string
+ * @b: second string
+ *
+ * Example:
+ *	if (streq(argv[1], "--help"))
+ *		printf("%s\n", "This help");
+ */
+#define streq(a, b) (strcmp((a), (b)) == 0)
+
+/**
  * strstarts - does @str start with @prefix?
  * @str: string to examine
  * @prefix: prefix to look for.
-- 
1.7.5.rc2.5.g60e19

