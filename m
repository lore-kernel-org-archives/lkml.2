Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603Ab2EQKME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:12:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761553Ab2EQKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:59 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 7/8] MIPS: smp: Warn on too early irq enable
Date: Thu, 17 May 2012 18:10:09 +0800
Message-Id: <1337249410-7162-8-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

Just to catch a potential issue.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 arch/mips/kernel/smp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 042145f..0d48598 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -130,6 +130,11 @@ asmlinkage __cpuinit void start_secondary(void)
 
 	synchronise_count_slave();
 
+	/*
+	 * irq will be enabled in ->smp_finish(), enable it too early
+	 * is dangerous.
+	 */
+	WARN_ON_ONCE(!irqs_disabled());
 	mp_ops->smp_finish();
 
 	cpu_idle();
-- 
1.7.1

