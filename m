Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1AFIAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:00:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61050 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab1AFIAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=LePnhoXZ6rivROwoFUckF3L0Kh3MCwyTlPKemuuVpNxkjXz9iGuWVm8ZyX0G+iQ74k
         qmyUMZuHteq1bNeQHT4UTpRp0bIQRTIXHGK+bH38KPXSncHmFiDDLrRuZ3U+Tx5Kr7Mn
         fqJ7oeGcx9XI2edPlz+QHTOhYP6aDTgAJvsXA=
From: Changli Gao <xiaosuo@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
        Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] net: remove the duplicate #ifdef __KERNEL__
Date: Thu,  6 Jan 2011 15:59:48 +0800
Message-Id: <1294300788-3540-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are already in #ifdef __KERNEL__, we don't need to check it
again.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 include/linux/socket.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 86b652f..5f65f14 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -30,12 +30,10 @@ struct cred;
 #define __sockaddr_check_size(size)	\
 	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
 
-#ifdef __KERNEL__
-# ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void socket_seq_show(struct seq_file *seq);
-# endif
-#endif /* __KERNEL__ */
+#endif
 
 typedef unsigned short	sa_family_t;
 
@@ -311,7 +309,6 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-#ifdef __KERNEL__
 extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
@@ -333,6 +330,5 @@ struct timespec;
 
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
-#endif
 #endif /* not kernel and not glibc */
 #endif /* _LINUX_SOCKET_H */
