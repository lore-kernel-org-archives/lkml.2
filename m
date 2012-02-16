Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab2BPTKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:10:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2BPTKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:10:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/3] Delete the __FD_*() funcs for operating on fd_set from
 linux/time.h
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hpa@zytor.com, torvalds@osdl.org, arnd@arndb.de, dhowells@redhat.com
Date: Thu, 16 Feb 2012 17:50:06 +0000
Message-ID: <20120216175006.23314.18984.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
References: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the __FD_*() functions for operating on fd_set structs from
linux/time.h as they're no longer used within the kernel with the preceding
patch and are not exported to userspace.

Whilst linux/time.h *does* export the FD_*() equivalents as wrappers around
__FD_*(), userspace provides its own definition of __FD_*().

Note that the definition of FD_ZERO() in linux/time.h may not be used with the
fd_sets associated with struct fdtable as the fd_set may have been allocated in
a truncated fashion.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/time.h |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index ca9b1e6..9f43487 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -4,9 +4,7 @@
 #include <linux/types.h>
 
 #ifdef __KERNEL__
-# include <linux/bitops.h>
 # include <linux/cache.h>
-# include <linux/posix_types.h>
 # include <linux/seqlock.h>
 # include <linux/math64.h>
 #endif
@@ -259,26 +257,6 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
 	a->tv_nsec = ns;
 }
 
-static inline void __FD_SET(unsigned long __fd, __kernel_fd_set *__fdsetp)
-{
-	__set_bit( __fd, __fdsetp->fds_bits);
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

