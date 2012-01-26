Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2AZPq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:46:27 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:29870 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2AZPq1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 26 Jan 2012 10:46:27 -0500
Message-Id: <4F2183A9020000780006F3E6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jan 2012 15:47:37 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: properly parenthesize cmpxchg() macro arguments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite oddly, all of the arguments passed through from the top level
macros to the second level which didn't need parentheses had them,
while the only expression (involving a parameter) needing them didn't.

Very recently I got bitten by the lack thereof when using something
like "array + index" for the first operand, with "array" being an
array more narrow than int.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/cmpxchg.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.3-rc1/arch/x86/include/asm/cmpxchg.h
+++ 3.3-rc1-x86-cmpxchg-parenthesize/arch/x86/include/asm/cmpxchg.h
@@ -145,13 +145,13 @@ extern void __add_wrong_size(void)
 
 #ifdef __HAVE_ARCH_CMPXCHG
 #define cmpxchg(ptr, old, new)						\
-	__cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define sync_cmpxchg(ptr, old, new)					\
-	__sync_cmpxchg((ptr), (old), (new), sizeof(*ptr))
+	__sync_cmpxchg(ptr, old, new, sizeof(*(ptr)))
 
 #define cmpxchg_local(ptr, old, new)					\
-	__cmpxchg_local((ptr), (old), (new), sizeof(*ptr))
+	__cmpxchg_local(ptr, old, new, sizeof(*(ptr)))
 #endif
 
 /*



