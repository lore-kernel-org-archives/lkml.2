Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab0GAV2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:28:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60244 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759253Ab0GAV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:28:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R6a22pAXN1DBtcB88/SGYO9PCI1Y3771Fz7yrU8+Ud74qyhF9vNPKqSreac/xJODm6
         Im+7zHYPZ70F9H7V7yBKLBJo3QSp/aMtTVRS3CELG30nKnrGmr0s5bIkxMXwBrK+kPuZ
         l70kUWLWLONUnKJG9NB/3QOXbPooqqJ2UnOWs=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, jkosina@suse.cz,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v3]kernel.h Move preprocessor #warning about using kernel headers in userpsace to types.h
Date: Thu,  1 Jul 2010 14:28:27 -0700
Message-Id: <1278019707-30585-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the preprocessor #warning message:
warning: #warning Attempt to use kernel headers from user space, 
see http://kernelnewbies.org/KernelHeaders
from kernel.h to types.h.
And also fixe the #warning message due to the preprocessor not being
able to read the web address due to it thinking it was the start of a comment.
also remove the extra #ifndef _KERNEL_ since it's already there.
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>

---
 include/linux/kernel.h |    6 ------
 include/linux/types.h  |    5 ++++-
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..bd8501a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -728,12 +728,6 @@ extern int do_sysinfo(struct sysinfo *info);
 
 #endif /* __KERNEL__ */
 
-#ifndef __EXPORTED_HEADERS__
-#ifndef __KERNEL__
-#warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
-#endif /* __KERNEL__ */
-#endif /* __EXPORTED_HEADERS__ */
-
 #define SI_LOAD_SHIFT	16
 struct sysinfo {
 	long uptime;			/* Seconds since boot */
diff --git a/include/linux/types.h b/include/linux/types.h
index 23d237a..331d8ba 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -8,7 +8,10 @@
 
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
-
+#else
+#ifndef __EXPORTED_HEADERS__
+#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
+#endif /* __EXPORTED_HEADERS__ */
 #endif
 
 #include <linux/posix_types.h>
-- 
1.6.5.2.180.gc5b3e

