Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab2DMTYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:24:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58894 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab2DMTYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:24:23 -0400
Subject: [PATCH][RESEND] do not redefine userspace's NULL #define
From: Lubos Lunak <l.lunak@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Date: Fri, 13 Apr 2012 21:24:20 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201204132124.21294.l.lunak@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GCC's NULL is actually __null, which allows detecting some questionable
NULL usage and warn about it. Moreover each platform/compiler should have
its own stddef.h anyway (which is different from linux/stddef.h).
So there's no good reason to override what the compiler provides.
Keep the #define conditionally, in order to keep the headers self-contained.

Signed-off-by: Luboš Luňák <l.lunak@suse.cz>
---

 There have been no further comments after this last version, and I do not see 
how this change should affect anything in either kernel builds or userspace 
builds, except for fixing the issue of overriding the proper NULL definition, 
so I consider this the proper and safe fix.

 include/linux/stddef.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 6a40c76..ce225a9 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -3,12 +3,13 @@
 
 #include <linux/compiler.h>
 
-#undef NULL
+#ifndef NULL
 #if defined(__cplusplus)
 #define NULL 0
 #else
 #define NULL ((void *)0)
 #endif
+#endif
 
 #ifdef __KERNEL__
 
-- 
1.7.7
-- 
 Lubos Lunak
 l.lunak@suse.cz
