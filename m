Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965878Ab2FBUgv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 16:36:51 -0400
Received: from georges.telenet-ops.be ([195.130.137.68]:38159 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965146Ab2FBUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 16:35:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/5] h8300/signal: Fix typo "statis"
Date: Sat,  2 Jun 2012 22:35:36 +0200
Message-Id: <1338669339-23214-3-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
References: <1338669339-23214-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keyword is "static", not "statis":

arch/h8300/kernel/signal.c:455:8: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'void'
arch/h8300/kernel/signal.c: In function 'do_notify_resume':
arch/h8300/kernel/signal.c:511:3: error: implicit declaration of function 'do_signal' [-Werror=implicit-function-declaration]
arch/h8300/kernel/signal.c: At top level:
arch/h8300/kernel/signal.c:414:1: warning: 'handle_signal' defined but not used [-Wunused-function]

Introduced in commit 7ae4e32a65148353db3458e3eb87117f25620ac5 ("h8300: switch
to saved_sigmask-based sigsuspend/rt_sigsuspend")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/h8300/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/kernel/signal.c b/arch/h8300/kernel/signal.c
index d4b0555..95e4de0 100644
--- a/arch/h8300/kernel/signal.c
+++ b/arch/h8300/kernel/signal.c
@@ -452,7 +452,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-statis void do_signal(struct pt_regs *regs)
+static void do_signal(struct pt_regs *regs)
 {
 	siginfo_t info;
 	int signr;
-- 
1.7.0.4

