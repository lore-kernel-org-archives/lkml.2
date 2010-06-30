Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab0F3WJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:09:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54863 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab0F3WJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EpE9iWzEfIo8b1swTrMlqEvV05Qg7rt5Ug+zfq6TvqwU1w1SOjjcqO75JRnYjTb2pD
         kUyR2yBZLkOmdr8huCLJwg072A0igT59kqHMjGWG0XzIkXd+CKukNOlVlNc4AL09HqlX
         MV9NR7ICoiVXbOhq48gMl4DZchtDQlE1bM0dk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, arnd@arndb.de, jkosina@suse.cz,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]kernel.h Move warning message about using kernel headers for userspace to types.h
Date: Wed, 30 Jun 2010 15:09:45 -0700
Message-Id: <1277935785-6023-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hopefully correct, as request move the function that checks
if userspace is using kernel headers, from kernel.h to types.h.
(Please check.)

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/kernel.h |    6 ------
 include/linux/types.h  |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

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
index 23d237a..41fe43d 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -179,6 +179,12 @@ typedef __u32 __bitwise __wsum;
 typedef unsigned __bitwise__ gfp_t;
 typedef unsigned __bitwise__ fmode_t;
 
+#ifndef __EXPORTED_HEADERS__
+#ifndef __KERNEL__
+#warning "Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders"
+#endif /* __KERNEL__ */
+#endif /* __EXPORTED_HEADERS__ */
+
 #ifdef CONFIG_PHYS_ADDR_T_64BIT
 typedef u64 phys_addr_t;
 #else
-- 
1.6.5.2.180.gc5b3e

