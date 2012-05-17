Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570Ab2EQKL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 06:11:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37225 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761506Ab2EQKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 06:11:21 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, david.daney@cavium.com
Subject: [PATCH 4/8] MIPS: Yosemite: delay irq enable to ->smp_finish()
Date: Thu, 17 May 2012 18:10:06 +0800
Message-Id: <1337249410-7162-5-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
References: <1337249410-7162-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
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
1.7.1

