Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2LTWkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:40:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LTWke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:40:34 -0500
Date: Thu, 20 Dec 2012 14:40:20 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-8f170faeb458532282dbfa870f456e42c11d1ebb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356030701-16284-28-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-28-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, apb_timer:
  remove unused variable percpu_timer
Git-Commit-ID: 8f170faeb458532282dbfa870f456e42c11d1ebb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Dec 2012 14:40:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f170faeb458532282dbfa870f456e42c11d1ebb
Gitweb:     http://git.kernel.org/tip/8f170faeb458532282dbfa870f456e42c11d1ebb
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 20 Dec 2012 14:11:36 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Dec 2012 11:49:39 -0800

x86, apb_timer: remove unused variable percpu_timer

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Link: http://lkml.kernel.org/r/1356030701-16284-28-git-send-email-sasha.levin@oracle.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
