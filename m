Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab1KOU2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:28:55 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38404 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab1KOU2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:28:52 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH tip/core/rcu 6/9] sparc: Make SPARC use the new is_idle_task() API
Date: Tue, 15 Nov 2011 12:28:02 -0800
Message-Id: <1321388885-11211-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20111115202736.GA11030@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
x-cbid: 11111520-8974-0000-0000-00000222CC28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

Change from direct comparison of ->pid with zero to is_idle_task().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/kernel/setup_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index fe1e3fc..ffb883d 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -84,7 +84,7 @@ static void prom_sync_me(void)
 
 	prom_printf("PROM SYNC COMMAND...\n");
 	show_free_areas(0);
-	if(current->pid != 0) {
+	if (!is_idle_task(current)) {
 		local_irq_enable();
 		sys_sync();
 		local_irq_disable();
-- 
1.7.3.2

