Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab0GUWiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 18:38:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:42862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab0GUWh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 18:37:57 -0400
Date: Wed, 21 Jul 2010 22:37:41 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1279731838-1522-5-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-5-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/xsave] x86, xsave: Make init_xstate_buf static
Message-ID: <tip-45c2d7f46211a0b1f6b425c59575c53145afc4b4@git.kernel.org>
Git-Commit-ID: 45c2d7f46211a0b1f6b425c59575c53145afc4b4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 22:37:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45c2d7f46211a0b1f6b425c59575c53145afc4b4
Gitweb:     http://git.kernel.org/tip/45c2d7f46211a0b1f6b425c59575c53145afc4b4
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 21 Jul 2010 19:03:55 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 Jul 2010 14:06:05 -0700

x86, xsave: Make init_xstate_buf static

The pointer is only used in xsave.c. Making it static.

Signed-off-by: Robert Richter <robert.richter@amd.com>
LKML-Reference: <1279731838-1522-5-git-send-email-robert.richter@amd.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/xsave.h |    1 -
 arch/x86/kernel/xsave.c      |   10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index d1b5f3a..0ae6b99 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -27,7 +27,6 @@
 
 extern unsigned int xstate_size;
 extern u64 pcntxt_mask;
-extern struct xsave_struct *init_xstate_buf;
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
 extern void xsave_init(void);
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 5adb7fb..3b44a9b 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -16,6 +16,11 @@
  */
 u64 pcntxt_mask;
 
+/*
+ * Represents init state for the supported extended state.
+ */
+static struct xsave_struct *init_xstate_buf;
+
 struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
 struct _fpx_sw_bytes fx_sw_reserved_ia32;
@@ -348,11 +353,6 @@ static void prepare_fx_sw_frame(void)
 #endif
 }
 
-/*
- * Represents init state for the supported extended state.
- */
-struct xsave_struct *init_xstate_buf;
-
 #ifdef CONFIG_X86_64
 unsigned int sig_xstate_size = sizeof(struct _fpstate);
 #endif
