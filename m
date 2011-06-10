Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab1FJNK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:10:57 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43863 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1FJNKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:54 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] sparc, exec: remove redundant addr_limit assignment
Date: Fri, 10 Jun 2011 15:10:53 +0200
Message-Id: <1307711453-17412-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so this
assignment of USER_DS is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/sparc/kernel/process_32.c |    3 +--
 arch/sparc/kernel/process_64.c |    3 ---
 2 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index c8cc461..f793742 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -380,8 +380,7 @@ void flush_thread(void)
 #endif
 	}
 
-	/* Now, this task is no longer a kernel thread. */
-	current->thread.current_ds = USER_DS;
+	/* This task is no longer a kernel thread. */
 	if (current->thread.flags & SPARC_FLAG_KTHREAD) {
 		current->thread.flags &= ~SPARC_FLAG_KTHREAD;
 
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index c158a95..d959cd0 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -368,9 +368,6 @@ void flush_thread(void)
 
 	/* Clear FPU register state. */
 	t->fpsaved[0] = 0;
-	
-	if (get_thread_current_ds() != ASI_AIUS)
-		set_fs(USER_DS);
 }
 
 /* It's a bit more tricky when 64-bit tasks are involved... */
-- 
1.5.6.5

