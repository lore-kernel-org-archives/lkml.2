Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2FTTTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:19:48 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:52451 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2FTTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:19:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mn10300: Fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout
Date: Wed, 20 Jun 2012 21:19:40 +0200
Message-Id: <1340219980-12369-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a610d6e672d6d3723e8da257ad4a8a288a8f2f89 ("pull clearing
RESTORE_SIGMASK into block_sigmask()") caused:

arch/mn10300/kernel/signal.c: In function 'handle_signal':
arch/mn10300/kernel/signal.c:462:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]

Add the missing return values, and restore the indentation while we're at
it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/mn10300/kernel/signal.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 6ab0bee..4d584ae 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -459,10 +459,11 @@ static int handle_signal(int sig,
 	else
 		ret = setup_frame(sig, ka, oldset, regs);
 	if (ret)
-		return;
+		return ret;
 
 	signal_delivered(sig, info, ka, regs,
-				 test_thread_flag(TIF_SINGLESTEP));
+			 test_thread_flag(TIF_SINGLESTEP));
+	return 0;
 }
 
 /*
-- 
1.7.0.4

