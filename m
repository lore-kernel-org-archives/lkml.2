Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1HSQzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:55:48 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57293 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397Ab1HSQrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:47:35 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/43] microblaze: No need to reset handler if SA_ONESHOT
Date: Fri, 19 Aug 2011 17:46:31 +0100
Message-Id: <1313772419-21951-16-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

get_signal_to_deliver() already resets the signal handler if
SA_ONESHOT is set in ka->sa.sa_flags, there's no need to do it again
in handle_signal(). Furthermore, because we were modifying
ka->sa.sa_handler (which is a copy of sighand->action[]) instead of
sighand->action[] the original code actually had no effect on signal
delivery.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/microblaze/kernel/signal.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/kernel/signal.c b/arch/microblaze/kernel/signal.c
index 90de06d..9e749c0 100644
--- a/arch/microblaze/kernel/signal.c
+++ b/arch/microblaze/kernel/signal.c
@@ -320,9 +320,6 @@ handle_signal(unsigned long sig, struct k_sigaction *ka,
 	else
 		setup_rt_frame(sig, ka, NULL, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	if (!(ka->sa.sa_flags & SA_NODEFER)) {
 		spin_lock_irq(&current->sighand->siglock);
 		sigorsets(&current->blocked,
-- 
1.7.4.4

