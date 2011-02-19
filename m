Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1BSMWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 07:22:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:42498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab1BSMWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 07:22:17 -0500
Date: Sat, 19 Feb 2011 12:22:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110202212551.667607458@linutronix.de>
References: <20110202212551.667607458@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Remove bogus conditional
Message-ID: <tip-3b56f0585fd4c02d047dc406668cb40159b2d340@git.kernel.org>
Git-Commit-ID: 3b56f0585fd4c02d047dc406668cb40159b2d340
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 12:22:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b56f0585fd4c02d047dc406668cb40159b2d340
Gitweb:     http://git.kernel.org/tip/3b56f0585fd4c02d047dc406668cb40159b2d340
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 21:41:12 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 19 Feb 2011 12:58:10 +0100

genirq: Remove bogus conditional

The if (chip->irq_shutdown) check will always evaluate to true, as we
fill in chip->irq_shutdown with default_shutdown in
irq_chip_set_defaults() if the chip does not provide its own function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.667607458@linutronix.de>
---
 kernel/irq/manage.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 33a6ee0..30bc8de 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1057,10 +1057,7 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
-		if (desc->irq_data.chip->irq_shutdown)
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-		else
-			desc->irq_data.chip->irq_disable(&desc->irq_data);
+		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 	}
 
 #ifdef CONFIG_SMP
