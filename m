Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0JGRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:09:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50605 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab0JGRJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:09:25 -0400
Date: Thu, 07 Oct 2010 18:09:24 +0100
To: linux-m68k@vger.kernel.org
Subject: [PATCH 1/6] m68k: resetting sa_handler in local copy of
 k_sigaction is pointless
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P3ty8-0007gs-G2@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and had been such since the introduction of get_signal_to_deliver()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m68k/kernel/signal.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/kernel/signal.c b/arch/m68k/kernel/signal.c
index 4b38753..c776c81 100644
--- a/arch/m68k/kernel/signal.c
+++ b/arch/m68k/kernel/signal.c
@@ -1006,9 +1006,6 @@ handle_signal(int sig, struct k_sigaction *ka, siginfo_t *info,
 	else
 		setup_frame(sig, ka, oldset, regs);
 
-	if (ka->sa.sa_flags & SA_ONESHOT)
-		ka->sa.sa_handler = SIG_DFL;
-
 	sigorsets(&current->blocked,&current->blocked,&ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
 		sigaddset(&current->blocked,sig);
-- 
1.5.6.5


