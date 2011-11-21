Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1KUDwZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 22:52:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38414 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1KUDwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 22:52:24 -0500
Date: Mon, 21 Nov 2011 03:52:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [patch] fix braino in um patchset (mea culpa)
Message-ID: <20111121035218.GE2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wrong register returned...
    
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/arch/x86/um/asm/processor.h b/arch/x86/um/asm/processor.h
index 936d7ac..04f82e0 100644
--- a/arch/x86/um/asm/processor.h
+++ b/arch/x86/um/asm/processor.h
@@ -11,7 +11,7 @@
 #endif
 
 #define KSTK_EIP(tsk) KSTK_REG(tsk, HOST_IP)
-#define KSTK_ESP(tsk) KSTK_REG(tsk, HOST_IP)
+#define KSTK_ESP(tsk) KSTK_REG(tsk, HOST_SP)
 #define KSTK_EBP(tsk) KSTK_REG(tsk, HOST_BP)
 
 #define ARCH_IS_STACKGROW(address) \
