Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0LJKzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 05:55:18 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:38510 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041Ab0LJKzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 05:55:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Zs/AaFkultfDyAD2uq7TT+sTvRtR38q17nXv1gHZc5GQfi1U03HCuKcka+RN/JylZl
         vJ1VL4YAD1BZjX1Rwa36r5Ctgdvqvrskg09Nop0k3cY1oRtFL1enVHSUs9RcaHm2ctUE
         bO3XqjLp2sVDVm+xgIEaBhG9jEGvpHPx5jZls=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [resend][PATCH] fs: use kernel's hex_to_bin() method
Date: Fri, 10 Dec 2010 12:55:05 +0200
Message-Id: <1291978505-29076-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
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
index 1befe2e..a0fb271 100644
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
1.7.2.3

