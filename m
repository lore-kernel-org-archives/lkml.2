Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab0HYBlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:41:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38781 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0HYBlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T7oUIqtk8jR7p8vhwGyfj2J1SIreXyh2Rv9ZnC9b+KwExWvCQ3mKt9t/WrQfInk5+N
         IMq5ZlVX/7u2ynijwPMvYku6aYyfpHtXrNwpszJeLzccfQYgcuyYftXvN+iNVV0UhJTR
         0qaOj44Vw4gJxDzsS/yCHVDUpVx5x4UEGPjK8=
From: Changli Gao <xiaosuo@gmail.com>
To: akpm@linux-foundation.org
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH v2] lib: fix scnprintf() if @size is == 0
Date: Wed, 25 Aug 2010 09:41:06 +0800
Message-Id: <1282700466-4938-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scnprintf() should return 0 if @size is == 0. Update the comment for it,
as @size is unsigned.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
v2: use if to improve readability and add likely()
 1 file changed, 6 insertions(+), 2 deletions(-)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7af9d84..f9c327a 100644
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
@@ -1509,7 +1509,11 @@ int scnprintf(char *buf, size_t size, const char *fmt, ...)
 	i = vsnprintf(buf, size, fmt, args);
 	va_end(args);
 
-	return (i >= size) ? (size - 1) : i;
+	if (likely(i < size))
+		return i;
+	if (size != 0)
+		return size - 1;
+	return 0;
 }
 EXPORT_SYMBOL(scnprintf);
 
