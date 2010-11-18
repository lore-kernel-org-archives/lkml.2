Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab0KROK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:10:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:41476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab0KROKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:10:23 -0500
Date: Thu, 18 Nov 2010 14:09:33 GMT
From: tip-bot for Sergio Aguirre <saaguirre@ti.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, kyle@mcmartin.ca,
        ying.huang@intel.com, saaguirre@ti.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, schwidefsky@de.ibm.com, kyle@mcmartin.ca,
        ying.huang@intel.com, saaguirre@ti.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
References: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] irq_work: Drop cmpxchg() result
Message-ID: <tip-94e8ba728640dc01375a14e337f3b892bfacbeeb@git.kernel.org>
Git-Commit-ID: 94e8ba728640dc01375a14e337f3b892bfacbeeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:09:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  94e8ba728640dc01375a14e337f3b892bfacbeeb
Gitweb:     http://git.kernel.org/tip/94e8ba728640dc01375a14e337f3b892bfacbeeb
Author:     Sergio Aguirre <saaguirre@ti.com>
AuthorDate: Tue, 16 Nov 2010 12:02:47 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 13:18:47 +0100

irq_work: Drop cmpxchg() result

The compiler warned us about:

 kernel/irq_work.c: In function 'irq_work_run':
 kernel/irq_work.c:148: warning: value computed is not used

Dropping the cmpxchg() result is indeed weird, but correct -
so annotate away the warning.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1289930567-17828-1-git-send-email-saaguirre@ti.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq_work.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f16763f..90f8819 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -145,7 +145,9 @@ void irq_work_run(void)
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
+		(void)cmpxchg(&entry->next,
+			      next_flags(NULL, IRQ_WORK_BUSY),
+			      NULL);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
