Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2DRUvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 16:51:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:35213 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab2DRUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 16:51:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Fleming <matt.fleming@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH] xtensa: fix build failure in xtensa/kernel/signal.c
Date: Wed, 18 Apr 2012 16:50:56 -0400
Message-Id: <1334782256-351-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caused by commit 3785006ac3c8941feb63097c416de92114a6bc39

    "xtensa: don't mask signals if we fail to setup signal stack"

It assigns a return value to "ret", but there is no such variable
anywhere in scope.  Create one.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
index b69b000..d78869a 100644
--- a/arch/xtensa/kernel/signal.c
+++ b/arch/xtensa/kernel/signal.c
@@ -496,6 +496,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
 	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
 
 	if (signr > 0) {
+		int ret;
 
 		/* Are we from a system call? */
 
-- 
1.7.9.1

