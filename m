Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2IBVeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46129 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab2IBVdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:03 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 2/7] x86, vdso: add __user annotation to VDSO32_SYMBOL
Date: Sun,  2 Sep 2012 23:31:41 +0200
Message-Id: <1346621506-30857-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address calculated by VDSO32_SYMBOL() is a pointer into userland.
Add the __user annotation to fix related sparse warnings in its users.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/include/asm/vdso.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index bb05228..fddb53d 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -11,7 +11,8 @@ extern const char VDSO32_PRELINK[];
 #define VDSO32_SYMBOL(base, name)					\
 ({									\
 	extern const char VDSO32_##name[];				\
-	(void *)(VDSO32_##name - VDSO32_PRELINK + (unsigned long)(base)); \
+	(void __user *)(VDSO32_##name - VDSO32_PRELINK +		\
+			(unsigned long)(base));				\
 })
 #endif
 
-- 
1.7.10.4

