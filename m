Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1G1Pvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:51:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab1G1Pvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:51:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/40] UAPI: Fix definition of HZ in asm-generic/param.h [ver
 #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:51:37 +0100
Message-ID: <20110728155136.16618.60616.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix definition of HZ in asm-generic/param.h so that the user-specific one is
#undef'd before the kernel-specific one is defined.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-generic/param.h |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/param.h b/include/asm-generic/param.h
index cdf8251..835632a 100644
--- a/include/asm-generic/param.h
+++ b/include/asm-generic/param.h
@@ -1,12 +1,6 @@
 #ifndef __ASM_GENERIC_PARAM_H
 #define __ASM_GENERIC_PARAM_H
 
-#ifdef __KERNEL__
-# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* some user interfaces are */
-# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
-#endif
-
 #ifndef HZ
 #define HZ 100
 #endif
@@ -21,4 +15,11 @@
 
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
+#ifdef __KERNEL__
+# undef HZ
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
+# define USER_HZ	100		/* some user interfaces are */
+# define CLOCKS_PER_SEC	(USER_HZ)       /* in "ticks" like times() */
+#endif
+
 #endif /* __ASM_GENERIC_PARAM_H */

