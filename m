Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab0HCEKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 00:10:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:45648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab0HCEKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 00:10:23 -0400
Date: Tue, 3 Aug 2010 04:10:06 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <4C5752F2.8030206@kernel.org>
References: <4C5752F2.8030206@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: move isdigit.h to ctype.h, header files on top.
Message-ID: <tip-6238b47b58480cd9c092600c05338dbe261b71ce@git.kernel.org>
Git-Commit-ID: 6238b47b58480cd9c092600c05338dbe261b71ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 04:10:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6238b47b58480cd9c092600c05338dbe261b71ce
Gitweb:     http://git.kernel.org/tip/6238b47b58480cd9c092600c05338dbe261b71ce
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 2 Aug 2010 21:03:46 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 2 Aug 2010 21:07:20 -0700

x86, setup: move isdigit.h to ctype.h, header files on top.

It is a subset of <ctype.h> functionality, so name it ctype.h.  Also,
reorganize header files so #include statements are clustered near the
top as they should be.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4C5752F2.8030206@kernel.org>
---
 arch/x86/boot/boot.h                 |    3 +--
 arch/x86/boot/compressed/misc.h      |    1 +
 arch/x86/boot/compressed/string.c    |    2 --
 arch/x86/boot/{isdigit.h => ctype.h} |    0
 4 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index 00cf51c..c7093bd 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -28,6 +28,7 @@
 #include "bitops.h"
 #include <asm/cpufeature.h>
 #include <asm/processor-flags.h>
+#include "ctype.h"
 
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
@@ -200,8 +201,6 @@ static inline int memcmp_gs(const void *s1, addr_t s2, size_t len)
 	return diff;
 }
 
-#include "isdigit.h"
-
 /* Heap -- available for dynamic lists. */
 extern char _end[];
 extern char *HEAP;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index a267849..3f19c81 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -20,6 +20,7 @@
 #include <asm/bootparam.h>
 
 #define BOOT_BOOT_H
+#include "../ctype.h"
 
 /* misc.c */
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
diff --git a/arch/x86/boot/compressed/string.c b/arch/x86/boot/compressed/string.c
index 7995c6a..19b3e69 100644
--- a/arch/x86/boot/compressed/string.c
+++ b/arch/x86/boot/compressed/string.c
@@ -1,4 +1,2 @@
 #include "misc.h"
-
-#include "../isdigit.h"
 #include "../string.c"
diff --git a/arch/x86/boot/isdigit.h b/arch/x86/boot/ctype.h
similarity index 100%
rename from arch/x86/boot/isdigit.h
rename to arch/x86/boot/ctype.h
