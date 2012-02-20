Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab2BTVRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 16:17:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37367 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2BTVRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 16:17:08 -0500
Date: Mon, 20 Feb 2012 13:16:18 -0800
From: tip-bot for David Howells <dhowells@redhat.com>
Message-ID: <tip-cf420048b3b2af9ce928d35cc5455c646c9dd2f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dhowells@redhat.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
In-Reply-To: <20120216175006.23314.18984.stgit@warthog.procyon.org.uk>
References: <20120216175006.23314.18984.stgit@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] Delete the __FD_*()
  funcs for operating on fd_set from linux/time.h
Git-Commit-ID: cf420048b3b2af9ce928d35cc5455c646c9dd2f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 20 Feb 2012 13:17:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf420048b3b2af9ce928d35cc5455c646c9dd2f7
Gitweb:     http://git.kernel.org/tip/cf420048b3b2af9ce928d35cc5455c646c9dd2f7
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Thu, 16 Feb 2012 17:50:06 +0000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 19 Feb 2012 10:32:28 -0800

Delete the __FD_*() funcs for operating on fd_set from linux/time.h

Delete the __FD_*() functions for operating on fd_set structs from
linux/time.h as they're no longer used within the kernel with the preceding
patch and are not exported to userspace.

Whilst linux/time.h *does* export the FD_*() equivalents as wrappers around
__FD_*(), userspace provides its own definition of __FD_*().

Note that the definition of FD_ZERO() in linux/time.h may not be used with the
fd_sets associated with struct fdtable as the fd_set may have been allocated in
a truncated fashion.

Signed-off-by: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120216175006.23314.18984.stgit@warthog.procyon.org.uk
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/time.h |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 93277a0..9f43487 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -4,11 +4,8 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
-# include <linux/bitops.h>
 # include <linux/cache.h>
-# include <linux/posix_types.h>
 # include <linux/seqlock.h>
-# include <linux/string.h>
 # include <linux/math64.h>
 #endif
 
@@ -260,26 +257,6 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_nsec = ns;
 }
 
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	__set_bit(__fd, __fdsetp->fds_bits);
-}
-
-static inline void __FD_CLR(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	__clear_bit(__fd, __fdsetp->fds_bits);
-}
-
-static inline int __FD_ISSET(unsigned long __fd, const __kernel_fd_set *__fdsetp)
-{
-	return test_bit(__fd, __fdsetp->fds_bits);
-}
-
-static inline void __FD_ZERO(__kernel_fd_set *__fdsetp)
-{
-	memset(__fdsetp->fds_bits, 0, sizeof __fdsetp->fds_bits);
-}
-
 #endif /* __KERNEL__ */
 
 #define NFDBITS			__NFDBITS
