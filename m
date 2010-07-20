Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab0GTS6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:58:21 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:14290 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432Ab0GTS6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:58:14 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L5VE0W-01-LM5-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/10] x86, xsave: make init_xstate_buf static
Date: Tue, 20 Jul 2010 20:50:57 +0200
Message-ID: <1279651857-24639-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
References: <1279651857-24639-1-git-send-email-robert.richter@amd.com>
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
index 49540b7..e7f3d39 100644
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


