Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0HKOVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:21:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43819 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab0HKOVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:21:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tZi4+kWucJksuayz4aYGUCXQa0z60Zc8u5kNHaozH4d+DpoVCiMT5cwHUxo1SLcTyj
         RTrKcER5cIBjR7nWE8ItJbJ0H6tR2jqk+YNG1fLOqDoh92e87YzJPROkE1IUC7Vyi2YE
         mqav3tkBEZ+JvL2N9e0q1bavxlSOZkNkY9i5A=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: use kernel's hex_to_bin() method
Date: Wed, 11 Aug 2010 17:21:03 +0300
Message-Id: <1281536463-10680-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/binfmt_misc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 9e60fd2..6c3855e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -28,6 +28,7 @@
 #include <linux/mount.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/kernel.h>
 
 #include <asm/uaccess.h>
 
@@ -244,10 +245,8 @@ static int unquote(char *from)
 	while ((c = *s++) != '\0') {
 		if (c == '\\' && *s == 'x') {
 			s++;
-			c = toupper(*s++);
-			*p = (c - (isdigit(c) ? '0' : 'A' - 10)) << 4;
-			c = toupper(*s++);
-			*p++ |= c - (isdigit(c) ? '0' : 'A' - 10);
+			*p = hex_to_bin(*s++) << 4;
+			*p++ |= hex_to_bin(*s++);
 			continue;
 		}
 		*p++ = c;
-- 
1.7.1.1

