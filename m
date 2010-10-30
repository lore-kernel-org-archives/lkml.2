Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab0J3VJs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:09:48 -0400
Received: from mail.perches.com ([173.55.12.10]:3792 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0J3VJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:45 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 30/39] kernel/irq: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:47 -0700
Message-Id: <d9b9752f32370fe22fa2673562a484817fe83c83.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/irq/chip.c   |    2 +-
 kernel/irq/manage.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index baa5c4a..1418f0a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -29,7 +29,7 @@ int set_irq_chip(unsigned int irq, struct irq_chip *chip)
 	unsigned long flags;
 
 	if (!desc) {
-		WARN(1, KERN_ERR "Trying to install chip for IRQ%d\n", irq);
+		WARN(1, "Trying to install chip for IRQ%d\n", irq);
 		return -EINVAL;
 	}
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 644e8d5..699475f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -288,7 +288,7 @@ void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 	switch (desc->depth) {
 	case 0:
  err_out:
-		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
+		WARN(1, "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
 		unsigned int status = desc->status & ~IRQ_DISABLED;
-- 
1.7.3.1.g432b3.dirty

