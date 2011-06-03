Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab1FCUH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:07:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753630Ab1FCUH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:07:27 -0400
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 5/4] x86, asm: Fix another binutils 2.16 issue
Date: Fri,  3 Jun 2011 22:07:22 +0200
Message-Id: <1307131642-32595-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.7.5.3.401.gfb674
In-Reply-To: <1306873314-32523-1-git-send-email-bp@alien8.de>
References: <1306873314-32523-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While testing the patchset at

http://lkml.kernel.org/r/1306873314-32523-1-git-send-email-bp@alien8.de

with binutils 2.16.1 from hell, kernel build fails with the following
error:

arch/x86/ia32/ia32entry.S: Assembler messages:
arch/x86/ia32/ia32entry.S:139: Error: too many positional arguments
make[2]: *** [arch/x86/ia32/ia32entry.o] Error 1
make[1]: *** [arch/x86/ia32] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [arch/x86] Error 2
make: *** Waiting for unfinished jobs....

due to spaces between the operators of the __USER32_CS define. Fix it so
that gas 2.16 can swallow it too.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/segment.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index cd84f72..5e64171 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -162,7 +162,7 @@
 #define GDT_ENTRY_DEFAULT_USER32_CS 4
 #define GDT_ENTRY_DEFAULT_USER_DS 5
 #define GDT_ENTRY_DEFAULT_USER_CS 6
-#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS * 8 + 3)
+#define __USER32_CS   (GDT_ENTRY_DEFAULT_USER32_CS*8+3)
 #define __USER32_DS	__USER_DS
 
 #define GDT_ENTRY_TSS 8	/* needs two entries */
-- 
1.7.5.3.401.gfb674

