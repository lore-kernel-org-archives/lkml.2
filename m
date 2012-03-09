Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2CIVL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:11:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33764 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab2CIVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:11:28 -0500
Date: Fri, 9 Mar 2012 13:10:51 -0800
From: tip-bot for Alexander Gordeev <agordeev@redhat.com>
Message-ID: <tip-540b60e24f3f4781d80e47122f0c4486a03375b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, agordeev@redhat.com, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, agordeev@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120309135912.GA2114@dhcp-26-207.brq.redhat.com>
References: <20120309135912.GA2114@dhcp-26-207.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq:
  Fix incorrect check for forced IRQ thread handler
Git-Commit-ID: 540b60e24f3f4781d80e47122f0c4486a03375b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 13:11:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  540b60e24f3f4781d80e47122f0c4486a03375b8
Gitweb:     http://git.kernel.org/tip/540b60e24f3f4781d80e47122f0c4486a03375b8
Author:     Alexander Gordeev <agordeev@redhat.com>
AuthorDate: Fri, 9 Mar 2012 14:59:13 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 9 Mar 2012 17:19:08 +0100

genirq: Fix incorrect check for forced IRQ thread handler

We do not want a bitwise AND between boolean operands

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: http://lkml.kernel.org/r/20120309135912.GA2114@dhcp-26-207.brq.redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index a9a9dbe..c0730ad 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -773,7 +773,7 @@ static int irq_thread(void *data)
 			struct irqaction *action);
 	int wake;
 
-	if (force_irqthreads & test_bit(IRQTF_FORCED_THREAD,
+	if (force_irqthreads && test_bit(IRQTF_FORCED_THREAD,
 					&action->thread_flags))
 		handler_fn = irq_forced_thread_fn;
 	else
