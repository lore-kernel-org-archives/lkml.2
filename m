Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343Ab1JFWY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:24:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44834 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab1JFWYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:24:25 -0400
From: Alex Ben <aleben358@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <Mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Alex Ben <aleben358@gmail.com>
Subject: [PATCH] x86: Removed superfluous parentheses in macro defs
Date: Fri,  7 Oct 2011 09:22:04 +1100
Message-Id: <1317939724-27924-1-git-send-email-aleben358@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) make it consistent with other constant macro deinitions, which
don't have parentheses, as they are really superfluous.

2) the extra parentheses on the 5th line of #define GDT_ENTRY is
superfluous, as there is no bit shifting on that line.
---
 arch/x86/include/asm/segment.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 5e64171..92621c1 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -10,7 +10,7 @@
	 (((flags) & _AC(0x0000f0ff,ULL)) << 40) |	\
	 (((limit) & _AC(0x000f0000,ULL)) << (48-16)) |	\
	 (((base)  & _AC(0x00ffffff,ULL)) << 16) |	\
-	 (((limit) & _AC(0x0000ffff,ULL))))
+	 ((limit)  & _AC(0x0000ffff,ULL)))

 /* Simple and small GDT entries for booting only */

@@ -75,7 +75,7 @@

 #define GDT_ENTRY_DEFAULT_USER_DS	15

-#define GDT_ENTRY_KERNEL_BASE		(12)
+#define GDT_ENTRY_KERNEL_BASE		12

 #define GDT_ENTRY_KERNEL_CS		(GDT_ENTRY_KERNEL_BASE+0)

--
1.7.4.1
