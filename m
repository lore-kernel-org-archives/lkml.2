Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1G1JkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:40:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:56854 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab1G1JkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:40:02 -0400
Date: Thu, 28 Jul 2011 09:39:57 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Message-ID: <tip-f3637a5f2e2eb391ff5757bc83fb5de8f9726464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] irq: Always set IRQF_ONESHOT if no primary handler is specified
Git-Commit-ID: f3637a5f2e2eb391ff5757bc83fb5de8f9726464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Jul 2011 09:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3637a5f2e2eb391ff5757bc83fb5de8f9726464
Gitweb:     http://git.kernel.org/tip/f3637a5f2e2eb391ff5757bc83fb5de8f9726464
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Thu, 7 Jul 2011 22:32:17 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 28 Jul 2011 11:23:21 +0200

irq: Always set IRQF_ONESHOT if no primary handler is specified

If no primary handler is specified then a default one is assigned
which always returns IRQ_WAKE_THREAD. This handler requires the
IRQF_ONESHOT flag on LEVEL / EIO typed irqs because the source of
interrupt is not disabled. Since it is required for those users and
there is no difference for others it makes sense to add this flag
unconditionally.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: http://lkml.kernel.org/r/1310070737-18514-1-git-send-email-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0a7840ae..3f9cd47 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1322,6 +1322,7 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 		if (!thread_fn)
 			return -EINVAL;
 		handler = irq_default_primary_handler;
+		irqflags |= IRQF_ONESHOT;
 	}
 
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
