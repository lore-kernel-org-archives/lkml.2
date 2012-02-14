Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608Ab2BNLoI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:44:08 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:57870 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932306Ab2BNLoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:44:01 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-arch@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 36/40] unicore32: Use block_sigmask()
Date: Tue, 14 Feb 2012 11:41:09 +0000
Message-Id: <1329219673-28711-37-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
References: <1329219673-28711-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Use the new helper function introduced in commit 5e6292c0f28f
("signal: add block_sigmask() for adding sigmask to current->blocked")
which centralises the code for updating current->blocked after
successfully delivering a signal and reduces the amount of duplicate
code across architectures. In the past some architectures got this
code wrong, so using this helper function should stop that from
happening again.

Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/unicore32/kernel/signal.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/unicore32/kernel/signal.c b/arch/unicore32/kernel/signal.c
index 911b549..72d9531 100644
--- a/arch/unicore32/kernel/signal.c
+++ b/arch/unicore32/kernel/signal.c
@@ -370,10 +370,7 @@ static int handle_signal(unsigned long sig, struct k_sigaction *ka,
 	/*
 	 * Block the signal if we were successful.
 	 */
-	sigorsets(&blocked, &tsk->blocked, &ka->sa.sa_mask);
-	if (!(ka->sa.sa_flags & SA_NODEFER))
-		sigaddset(&blocked, sig);
-	set_current_blocked(&blocked);
+	block_sigmask(ka, sig);
 
 	return 0;
 }
-- 
1.7.4.4

