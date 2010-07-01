Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0GAROp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:14:45 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57008 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0GAROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=B81ulxM4LS/97pojxOocVmcT4LAcJVR0esKdkfoSk0dDpif5WDQ7AvgUpoSPa6Qh4V
         AwAvBnG120ucihVPBRqp6nsyHS3DJ9FdEIH75odBPuIjHfkeoPbqwKWjiYU8Di7W6r2Z
         1xmbLlH3EU+wqoOvaq4QHfY3HFO3hxHBF5y6E=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, jkosina@suse.cz,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]kernel.h Move preprocessor #warning about using kernel headers in userpsace to types.h
Date: Thu,  1 Jul 2010 10:14:59 -0700
Message-Id: <1278004499-30182-1-git-send-email-justinmattock@gmail.com>
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
Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/kernel.h |    6 ------
 include/linux/types.h  |    7 ++++++-
 2 files changed, 6 insertions(+), 7 deletions(-)

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
index 23d237a..1be69b8 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -8,7 +8,12 @@
 
 #define DECLARE_BITMAP(name,bits) \
 	unsigned long name[BITS_TO_LONGS(bits)]
-
+#else
+#ifndef __EXPORTED_HEADERS__
+#ifndef __KERNEL__
+#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
+#endif /* __KERNEL__ */
+#endif /* __EXPORTED_HEADERS__ */
 #endif
 
 #include <linux/posix_types.h>
-- 
1.6.5.2.180.gc5b3e

