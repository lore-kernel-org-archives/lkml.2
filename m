Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0IFOhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:37:17 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33640 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754205Ab0IFOhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:37:01 -0400
Date: Mon, 6 Sep 2010 16:36:59 +0200
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
To: "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
Subject: [PATCH 12/14] include/linux: Removing undead ifdef __KERNEL__
Message-ID: <982ff35c4e79349b4bc4a224a6134e1c5ec38431.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __KERNEL__ ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 include/linux/socket.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index a2fada9..09753f5 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -30,12 +30,10 @@ struct cred;
 #define __sockaddr_check_size(size)	\
 	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
 
-#ifdef __KERNEL__
 # ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void socket_seq_show(struct seq_file *seq);
 # endif
-#endif /* __KERNEL__ */
 
 typedef unsigned short	sa_family_t;
 
@@ -311,7 +309,6 @@ struct ucred {
 /* IPX options */
 #define IPX_TYPE	1
 
-#ifdef __KERNEL__
 extern void cred_to_ucred(struct pid *pid, const struct cred *cred, struct ucred *ucred);
 
 extern int memcpy_fromiovec(unsigned char *kdata, struct iovec *iov, int len);
@@ -334,6 +331,5 @@ struct timespec;
 
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
-#endif
-#endif /* not kernel and not glibc */
+#endif /* __KERNEL__ */
 #endif /* _LINUX_SOCKET_H */
-- 
1.7.0.4

