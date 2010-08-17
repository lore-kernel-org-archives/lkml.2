Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab0HQKgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:36:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56069 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0HQKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=sh6O3g8M8kHKDCp7GiCjge5ayEeccSy9WU5Ybq5eyH+lpkZP2F6ApJlG2BugFJeqcU
         xdlrUFlNzmmk5MKi0nhWcDx/PJrmchLnLZDU+rXFvAUDb6KwMfP2IBbJQvshfYWi0PlA
         k+kcA0XjfTO7Kpc55dOxgUPD4A80yWF9kZGgg=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH][resend] scripts/mod/modpost.c: fix commentary accordingly to last changes
Date: Tue, 17 Aug 2010 13:36:40 +0300
Message-Id: <1282041400-32667-1-git-send-email-ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last commits
 37ed19d5cce35a40d3913cf9aa208ce9f60db3d7
 5003bab82d56754b27be01eef24495a02e00039d
have introduced new behaviour of sec2annotation() method. However, the
commentary inside the method was left as before. Let's fix it accordingly.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/mod/modpost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1ec7158..33122ca 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1208,6 +1208,9 @@ static Elf_Sym *find_elf_symbol2(struct elf_info *elf, Elf_Addr addr,
  * .cpuinit.data => __cpudata
  * .memexitconst => __memconst
  * etc.
+ *
+ * The memory of returned value has been allocated on a heap. The user of this
+ * method should free it after usage.
 */
 static char *sec2annotation(const char *s)
 {
@@ -1230,7 +1233,7 @@ static char *sec2annotation(const char *s)
 			strcat(p, "data ");
 		else
 			strcat(p, " ");
-		return r; /* we leak her but we do not care */
+		return r;
 	} else {
 		return strdup("");
 	}
-- 
1.6.3.3

