Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab0DSVx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:53:26 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:48584 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab0DSVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:53:22 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 2/5] uml: Drop private round_down definition
Date: Mon, 19 Apr 2010 23:53:05 +0200
Message-Id: <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18rXBy7fVIuG0QUF7ONL8n7L95T3d4MH5n5/FF3
	889SlVFb8FGhVn5TYVEaRb8mxcjYGajX5Ueg4yhm9Rt2T1mRP+
	BucmHw08A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Already defined in kernel.h. The official version assumes that 'n' is
power of two - which it is in our case.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 arch/um/sys-x86_64/signal.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
index 1a899a7..07797d1 100644
--- a/arch/um/sys-x86_64/signal.c
+++ b/arch/um/sys-x86_64/signal.c
@@ -165,8 +165,6 @@ struct rt_sigframe
 	struct _fpstate fpstate;
 };
 
-#define round_down(m, n) (((m) / (n)) * (n))
-
 int setup_signal_stack_si(unsigned long stack_top, int sig,
 			  struct k_sigaction *ka, struct pt_regs * regs,
 			  siginfo_t *info, sigset_t *set)
-- 
1.6.0.2

