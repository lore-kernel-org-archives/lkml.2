Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab2EUGAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:00:54 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63504 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2EUGAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:00:33 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com
Subject: [PATCH 1/8] MIPS: Octeon: delay enable irq to ->smp_finish()
Date: Mon, 21 May 2012 14:00:01 +0800
Message-Id: <1337580008-7280-2-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
References: <1337580008-7280-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

To prepare for smoothing set_cpu_[active|online]() mess up

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Acked-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index 97e7ce9..ef9c34a 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -185,7 +185,6 @@ static void __cpuinit octeon_init_secondary(void)
 	octeon_init_cvmcount();
 
 	octeon_irq_setup_secondary();
-	raw_local_irq_enable();
 }
 
 /**
@@ -233,6 +232,7 @@ static void octeon_smp_finish(void)
 
 	/* to generate the first CPU timer interrupt */
 	write_c0_compare(read_c0_count() + mips_hpt_frequency / HZ);
+	local_irq_enable();
 }
 
 /**
-- 
1.7.5.4

