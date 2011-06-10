Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab1FJNJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:09:33 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43065 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab1FJNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:09:29 -0400
From: Mathias Krause <minipli@googlemail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] frv, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:09:28 +0200
Message-Id: <1307711368-7279-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Also removed the dead code in flush_thread().

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/frv/include/asm/processor.h |    1 -
 arch/frv/kernel/process.c        |    5 +----
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/frv/include/asm/processor.h b/arch/frv/include/asm/processor.h
index 4b789ab..81c2e27 100644
--- a/arch/frv/include/asm/processor.h
+++ b/arch/frv/include/asm/processor.h
@@ -97,7 +97,6 @@ extern struct task_struct *__kernel_current_task;
  */
 #define start_thread(_regs, _pc, _usp)			\
 do {							\
-	set_fs(USER_DS); /* reads from user space */	\
 	__frame = __kernel_frame0_ptr;			\
 	__frame->pc	= (_pc);			\
 	__frame->psr	&= ~PSR_S;			\
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 9d35975..3901df1 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -143,10 +143,7 @@ void machine_power_off(void)
 
 void flush_thread(void)
 {
-#if 0 //ndef NO_FPU
-	unsigned long zero = 0;
-#endif
-	set_fs(USER_DS);
+	/* nothing */
 }
 
 inline unsigned long user_stack(const struct pt_regs *regs)
-- 
1.5.6.5

