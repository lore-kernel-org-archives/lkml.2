Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2EUGB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:01:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37552 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2EUGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:01:26 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 4/8] MIPS: Yosemite: delay irq enable to ->smp_finish()
Date: Mon, 21 May 2012 14:00:04 +0800
Message-Id: <1337580008-7280-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/pmc-sierra/yosemite/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
index b71fae2..5edab2b 100644
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -115,11 +115,11 @@ static void yos_send_ipi_mask(const struct cpumask *mask, unsigned int action)
  */
 static void __cpuinit yos_init_secondary(void)
 {
-	set_c0_status(ST0_CO | ST0_IE | ST0_IM);
 }
 
 static void __cpuinit yos_smp_finish(void)
 {
+	set_c0_status(ST0_CO | ST0_IM | ST0_IE);
 }
 
 /* Hook for after all CPUs are online */
-- 
1.7.5.4

