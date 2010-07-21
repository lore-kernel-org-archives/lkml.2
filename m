Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0GURXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:23:00 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:30685
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061Ab0GURWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:22:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i2a8h87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5X434-01-7F1-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 4/7] x86, xsave: make init_xstate_buf static
Date: Wed, 21 Jul 2010 19:03:55 +0200
Message-ID: <1279731838-1522-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
References: <1279731838-1522-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer is only used in xsave.c. Making it static.

Signed-off-by: Robert Richter <robert.richter@amd.com>
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
-- 
1.7.1.1


