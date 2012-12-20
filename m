Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2LTTPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:15:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49147 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2LTTOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:14:16 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, apb_timer: remove unused variable percpu_timer
Date: Thu, 20 Dec 2012 14:11:36 -0500
Message-Id: <1356030701-16284-28-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/x86/kernel/apb_timer.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index afdc3f75..cc74fd0 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -311,7 +311,6 @@ void __init apbt_time_init(void)
 #ifdef CONFIG_SMP
 	int i;
 	struct sfi_timer_table_entry *p_mtmr;
-	unsigned int percpu_timer;
 	struct apbt_dev *adev;
 #endif
 
@@ -346,13 +345,10 @@ void __init apbt_time_init(void)
 		return;
 	}
 	pr_debug("%s: %d CPUs online\n", __func__, num_online_cpus());
-	if (num_possible_cpus() <= sfi_mtimer_num) {
-		percpu_timer = 1;
+	if (num_possible_cpus() <= sfi_mtimer_num)
 		apbt_num_timers_used = num_possible_cpus();
-	} else {
-		percpu_timer = 0;
+	else
 		apbt_num_timers_used = 1;
-	}
 	pr_debug("%s: %d APB timers used\n", __func__, apbt_num_timers_used);
 
 	/* here we set up per CPU timer data structure */
-- 
1.8.0

