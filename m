Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2GMVUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 17:20:50 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:47405 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab2GMVUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 17:20:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hirokazu Takata <takata@linux-m32r.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/6] m32r: Fix pull clearing RESTORE_SIGMASK into block_sigmask() fallout
Date: Fri, 13 Jul 2012 23:20:23 +0200
Message-Id: <1342214427-17607-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
References: <1342214427-17607-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a610d6e672d6d3723e8da257ad4a8a288a8f2f89 ("pull clearing
RESTORE_SIGMASK into block_sigmask()") caused:

arch/m32r/kernel/signal.c: In function 'handle_signal':
arch/m32r/kernel/signal.c:289:6: warning: 'return' with a value, in function returning void [enabled by default]

Remove the return value it forgot to remove.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/m32r/kernel/signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/signal.c b/arch/m32r/kernel/signal.c
index f3fb2c0..d0f60b9 100644
--- a/arch/m32r/kernel/signal.c
+++ b/arch/m32r/kernel/signal.c
@@ -286,7 +286,7 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 			case -ERESTARTNOINTR:
 				regs->r0 = regs->orig_r0;
 				if (prev_insn(regs) < 0)
-					return -EFAULT;
+					return;
 		}
 	}
 
-- 
1.7.0.4

