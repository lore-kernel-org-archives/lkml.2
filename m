Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab1IZKYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:24:52 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:59953 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240Ab1IZKYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:24:51 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 1/2] alpha: Wire up accept4 syscall.
Date: Mon, 26 Sep 2011 22:20:48 +1300
Message-Id: <1317028849-13198-2-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
In-Reply-To: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
References: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 26 Sep 2011 22:21:41 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Sep 26 22:21:42 2011
X-DSPAM-Confidence: 0.7010
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somehow wiring up the accept4 syscall on Alpha was missed long ago.
This commit rectifies that oversight.

Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/unistd.h |    3 ++-
 arch/alpha/kernel/systbls.S     |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 4ac48a0..1fbfd64 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -457,10 +457,11 @@
 #define __NR_clock_adjtime		499
 #define __NR_syncfs			500
 #define __NR_setns			501
+#define __NR_accept4			502
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			502
+#define NR_SYSCALLS			503
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index b9c28f3..b24574f 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -520,6 +520,7 @@ sys_call_table:
 	.quad sys_clock_adjtime
 	.quad sys_syncfs			/* 500 */
 	.quad sys_setns
+	.quad sys_accept4
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.7.4.3

