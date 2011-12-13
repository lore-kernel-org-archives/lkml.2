Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab1LMKku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:50 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52215 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab1LMKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:47 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
Subject: [PATCH 05/17] UAPI: Make M32R use asm-generic/param.h
Date: Tue, 13 Dec 2011 10:04:01 +0000
Message-Id: <1323770653-19177-6-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make M32R use the generic settings to be found in asm-generic/param.h rather
than defining its own as they're exactly the same.

This sorts out a problem with HZ being redefined after the splitting of
userspace headers from kernel headers.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hirokazu Takata <takata@linux-m32r.org>
cc: linux-m32r@ml.linux-m32r.org
---
 arch/m32r/include/asm/param.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/arch/m32r/include/asm/param.h b/arch/m32r/include/asm/param.h
index 94c7701..fa207bd 100644
--- a/arch/m32r/include/asm/param.h
+++ b/arch/m32r/include/asm/param.h
@@ -1,23 +1,7 @@
 #ifndef _ASM_M32R_PARAM_H
 #define _ASM_M32R_PARAM_H
 
-#ifdef __KERNEL__
-# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-# define USER_HZ	100		/* .. some user interfaces are in "ticks" */
-# define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
-#endif
-
-#ifndef HZ
-#define HZ 100
-#endif
-
-#define EXEC_PAGESIZE	4096
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
+#include <asm-generic/param.h>
 
 #endif /* _ASM_M32R_PARAM_H */
 
-- 
1.7.7.4

