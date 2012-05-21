Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2EUGCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:02:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48354 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab2EUGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:02:29 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 8/8] MIPS: sync-r4k: remove redundant irq operation
Date: Mon, 21 May 2012 14:00:08 +0800
Message-Id: <1337580008-7280-9-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Since we have delayed irq enabling to ->smp_finish()

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/sync-r4k.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/mips/kernel/sync-r4k.c b/arch/mips/kernel/sync-r4k.c
index 99f913c..842d55e 100644
--- a/arch/mips/kernel/sync-r4k.c
+++ b/arch/mips/kernel/sync-r4k.c
@@ -111,7 +111,6 @@ void __cpuinit synchronise_count_master(void)
 void __cpuinit synchronise_count_slave(void)
 {
 	int i;
-	unsigned long flags;
 	unsigned int initcount;
 	int ncpus;
 
@@ -123,8 +122,6 @@ void __cpuinit synchronise_count_slave(void)
 	return;
 #endif
 
-	local_irq_save(flags);
-
 	/*
 	 * Not every cpu is online at the time this gets called,
 	 * so we first wait for the master to say everyone is ready
@@ -154,7 +151,5 @@ void __cpuinit synchronise_count_slave(void)
 	}
 	/* Arrange for an interrupt in a short while */
 	write_c0_compare(read_c0_count() + COUNTON);
-
-	local_irq_restore(flags);
 }
 #undef NR_LOOPS
-- 
1.7.5.4

