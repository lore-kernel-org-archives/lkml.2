Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab0HXXfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:35:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36698 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932633Ab0HXXfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PEi186XkUYgGS/zWjcH1d3p7e/oGGUiPLdqA8kQg5alYCQAoKpwR0e11bZsI2N1bwb
         HOTR23bzWsPP0/5LGxdNO0kkIaycI00Wmw8p32bkMPw7pPls9mAGGXKV49CQW89tRprv
         94xwW0hrmOP9pKDyO5OLDL0zWqKhQQWTiAMpA=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] lib: fix scnprintf() if @size is == 0
Date: Wed, 25 Aug 2010 07:35:02 +0800
Message-Id: <1282692902-2981-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scnprintf() should return 0 if @size is == 0. Update the comment for it,
as @size is unsigned.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7af9d84..0c66ae9 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1497,7 +1497,7 @@ EXPORT_SYMBOL(snprintf);
  * @...: Arguments for the format string
  *
  * The return value is the number of characters written into @buf not including
- * the trailing '\0'. If @size is <= 0 the function returns 0.
+ * the trailing '\0'. If @size is == 0 the function returns 0.
  */
 
 int scnprintf(char *buf, size_t size, const char *fmt, ...)
@@ -1509,7 +1509,7 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
 
-	return (i >= size) ? (size - 1) : i;
+	return (i >= size) ? (size != 0 ? (size - 1) : 0) : i;
 }
 EXPORT_SYMBOL(scnprintf);
 
