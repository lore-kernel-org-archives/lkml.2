Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1LMKlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:41:39 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1LMKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:12 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 07/17] UAPI: Rearrange definition of HZ in asm-generic/param.h
Date: Tue, 13 Dec 2011 10:04:03 +0000
Message-Id: <1323770653-19177-8-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the definition of HZ in asm-generic/param.h so that the user-specific
is declared before the kernel-specific one.  We then explicitly #undef the
userspace HZ value and replace it with the kernel HZ value.

This allows the userspace params to be excised into a separate header as part
of the UAPI header split.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
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
-- 
1.7.7.4

