Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1H3F17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:27:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:49082 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1H3F15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:27:57 -0400
Date: Tue, 30 Aug 2011 05:27:28 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-61e2cd0acc248c14793cefd7e23e209be9e0b70d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, cmpxchg: Use __compiletime_error() to make usage messages a bit nicer
Git-Commit-ID: 61e2cd0acc248c14793cefd7e23e209be9e0b70d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:27:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61e2cd0acc248c14793cefd7e23e209be9e0b70d
Gitweb:     http://git.kernel.org/tip/61e2cd0acc248c14793cefd7e23e209be9e0b70d
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Mon, 29 Aug 2011 14:47:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 17:20:40 -0700

x86, cmpxchg: Use __compiletime_error() to make usage messages a bit nicer

Use __compiletime_error() to produce a compile-time error rather than
link-time, where available.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg.h |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index 0d0d9cd..5d3acdf 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -1,12 +1,19 @@
 #ifndef ASM_X86_CMPXCHG_H
 #define ASM_X86_CMPXCHG_H
 
+#include <linux/compiler.h>
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-/* Non-existant functions to indicate usage errors at link time. */
-extern void __xchg_wrong_size(void);
-extern void __cmpxchg_wrong_size(void);
-extern void __xadd_wrong_size(void);
+/*
+ * Non-existant functions to indicate usage errors at link time
+ * (or compile-time if the compiler implements __compiletime_error().
+ */
+extern void __xchg_wrong_size(void)
+	__compiletime_error("Bad argument size for xchg");
+extern void __cmpxchg_wrong_size(void)
+	__compiletime_error("Bad argument size for cmpxchg");
+extern void __xadd_wrong_size(void)
+	__compiletime_error("Bad argument size for xadd");
 
 /*
  * Constants for operation sizes. On 32-bit, the 64-bit size it set to
