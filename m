Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0F2TpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 15:45:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62344 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0F2TpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 15:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YHG3yLtxpxo/MXJtDfBLpl+mSCJ9myEesREGFNCwvY+4FRmaVcc2B4Dw3ZtJslTXgL
         7BbCeIAR9fp6j9XsuTKXPo8h5EiNzBPpvfBpKZQtAYuPTqUpwr6HZm0Lm3hAmSkZnnE8
         UNJ9GV+7Rd5u+g3J4C0tUhBZhnr7uk9VDmhhA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]kernel.h Fix #warning message web address.
Date: Tue, 29 Jun 2010 12:37:24 -0700
Message-Id: <1277840244-3436-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Playing around with a printk program I noticed that the #warning
message is incomplete(when using kernel headers for userspace):

 gcc printk.c -o printk
In file included from printk.c:3:
include/linux/kernel.h:733:2: warning: #warning Attempt to use kernel headers from user space, see http:

My guess for the web address not being displayed is "//" is treated as a comment.
So after changing "http://" to "www." I get the web address.(using firefox with this
address takes me right to the location). The warning looks like this:

In file included from printk.c:3:
warning: #warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders 
 
 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 include/linux/kernel.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..768196a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -730,7 +730,7 @@ extern int do_sysinfo(struct sysinfo *info);
 
 #ifndef __EXPORTED_HEADERS__
 #ifndef __KERNEL__
-#warning Attempt to use kernel headers from user space, see http://kernelnewbies.org/KernelHeaders
+#warning Attempt to use kernel headers from user space, see www.kernelnewbies.org/KernelHeaders
 #endif /* __KERNEL__ */
 #endif /* __EXPORTED_HEADERS__ */
 
-- 
1.6.5.2.180.gc5b3e

