Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0LFWGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:06:52 -0500
Received: from mail.perches.com ([173.55.12.10]:2332 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/29] kernel/irq: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:12 -0800
Message-Id: <c706eb4e5124075b8a228b23e7b405e6cf60bd1d.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
index 91a5fa2..be8e055 100644
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
1.7.3.2.245.g03276.dirty

