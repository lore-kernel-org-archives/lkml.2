Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab2DSARZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 20:17:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2DSARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 20:17:24 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/5] x86, nop: Make the ASM_NOP* macros work from assembly
Date: Wed, 18 Apr 2012 17:16:46 -0700
Message-Id: <1334794610-5546-2-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 18 Apr 2012 17:17:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Make the ASM_NOP* macros work in actual assembly files.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/nops.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index 405b403..aff2b33 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -87,7 +87,11 @@
 #define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
 #define P6_NOP5_ATOMIC P6_NOP5
 
+#ifdef __ASSEMBLY__
+#define _ASM_MK_NOP(x) .byte x
+#else
 #define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
+#endif
 
 #if defined(CONFIG_MK7)
 #define ASM_NOP1 _ASM_MK_NOP(K7_NOP1)
-- 
1.7.6.5

