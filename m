Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1IZKYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 06:24:49 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:42793 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1IZKYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 06:24:48 -0400
From: Michael Cree <mcree@orcon.net.nz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 2/2] alpha: Wire up sendmmsg syscall
Date: Mon, 26 Sep 2011 22:20:49 +1300
Message-Id: <1317028849-13198-3-git-send-email-mcree@orcon.net.nz>
X-Mailer: git-send-email 1.7.4.3
In-Reply-To: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
References: <1317028849-13198-1-git-send-email-mcree@orcon.net.nz>
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 26 Sep 2011 22:21:44 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Sep 26 22:21:45 2011
X-DSPAM-Confidence: 0.7010
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Michael Cree <mcree@orcon.net.nz>
---
 arch/alpha/include/asm/unistd.h |    3 ++-
 arch/alpha/kernel/systbls.S     |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/unistd.h b/arch/alpha/include/asm/unistd.h
index 1fbfd64..2207fc6 100644
--- a/arch/alpha/include/asm/unistd.h
+++ b/arch/alpha/include/asm/unistd.h
@@ -458,10 +458,11 @@
 #define __NR_syncfs			500
 #define __NR_setns			501
 #define __NR_accept4			502
+#define __NR_sendmmsg			503
 
 #ifdef __KERNEL__
 
-#define NR_SYSCALLS			503
+#define NR_SYSCALLS			504
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/alpha/kernel/systbls.S b/arch/alpha/kernel/systbls.S
index b24574f..f3cb4f8 100644
--- a/arch/alpha/kernel/systbls.S
+++ b/arch/alpha/kernel/systbls.S
@@ -521,6 +521,7 @@ sys_call_table:
 	.quad sys_syncfs			/* 500 */
 	.quad sys_setns
 	.quad sys_accept4
+	.quad sys_sendmmsg
 
 	.size sys_call_table, . - sys_call_table
 	.type sys_call_table, @object
-- 
1.7.4.3

