Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab2EUGCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:02:19 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37552 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2EUGCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:02:15 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 7/8] MIPS: smp: Warn on too early irq enable
Date: Mon, 21 May 2012 14:00:07 +0800
Message-Id: <1337580008-7280-8-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Just to catch a potential issue.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/kernel/smp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 042145f..4fbafa8 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -130,6 +130,11 @@ asmlinkage __cpuinit void start_secondary(void)
 
 	synchronise_count_slave();
 
+	/*
+	 * irq will be enabled in ->smp_finish(), enabling it too early
+	 * is dangerous.
+	 */
+	WARN_ON_ONCE(!irqs_disabled());
 	mp_ops->smp_finish();
 
 	cpu_idle();
-- 
1.7.5.4

