Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1EVOv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 10:51:26 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43795 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1EVOu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 10:50:59 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 7/7] um: fix crash while os_dump_core()
Date: Sun, 22 May 2011 16:48:36 +0200
Message-Id: <1306075716-20042-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1306075716-20042-1-git-send-email-richard@nod.at>
References: <1306075716-20042-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

os_dump_core() emits SIGTERM to terminate all UML processes.
Kernel threads have to exit on SIGTERM instead of calling
last_ditch_exit().
Multiple calls to last_ditch_exit() can cause a crash.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/process.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/um/os-Linux/process.c b/arch/um/os-Linux/process.c
index e0477c3..0c45dc8 100644
--- a/arch/um/os-Linux/process.c
+++ b/arch/um/os-Linux/process.c
@@ -253,6 +253,7 @@ void init_new_thread_signals(void)
 		    SA_ONSTACK | SA_RESTART, SIGUSR1, SIGIO, SIGWINCH, SIGALRM,
 		    SIGVTALRM, -1);
 	signal(SIGWINCH, SIG_IGN);
+	signal(SIGTERM, SIG_DFL);
 }
 
 int run_kernel_thread(int (*fn)(void *), void *arg, jmp_buf **jmp_ptr)
-- 
1.7.4.2

