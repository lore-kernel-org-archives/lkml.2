Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab1LMKkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:40:14 -0500
Received: from warthog.procyon.org.uk ([90.155.74.18]:52178 "EHLO
	warthog.procyon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1LMKkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:40:09 -0500
From: David Howells <dhowells@redhat.com>
To: sfr@canb.auug.org.au, torvalds@linux-foundation.org
Cc: arnd@arndb.de, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH 04/17] UAPI: Make MN10300 use asm-generic/param.h
Date: Tue, 13 Dec 2011 10:04:00 +0000
Message-Id: <1323770653-19177-5-git-send-email-dhowells@redhat.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
References: <1323770653-19177-1-git-send-email-dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make MN10300 use the generic settings to be found in asm-generic/param.h
rather than defining its own as they're exactly the same.

This sorts out a problem with HZ being redefined after the UAPI split.

Signed-off-by: David Howells <dhowells@redhat.com>
---
 arch/mn10300/include/asm/param.h |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/arch/mn10300/include/asm/param.h b/arch/mn10300/include/asm/param.h
index 789b1df..02a0ca6 100644
--- a/arch/mn10300/include/asm/param.h
+++ b/arch/mn10300/include/asm/param.h
@@ -11,24 +11,8 @@
 #ifndef _ASM_PARAM_H
 #define _ASM_PARAM_H
 
-#ifdef __KERNEL__
-#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
-#define USER_HZ		100		/* .. some user interfaces are in
-					 * "ticks" */
-#define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
-#endif
+#include <asm-generic/param.h>
 
-#ifndef HZ
-#define HZ		100
-#endif
-
-#define EXEC_PAGESIZE	4096
-
-#ifndef NOGROUP
-#define NOGROUP		(-1)
-#endif
-
-#define MAXHOSTNAMELEN	64	/* max length of hostname */
 #define COMMAND_LINE_SIZE 256
 
 #endif /* _ASM_PARAM_H */
-- 
1.7.7.4

