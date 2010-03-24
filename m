Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab0CXNkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:40:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:56479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab0CXNkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:40:23 -0400
Date: Wed, 24 Mar 2010 13:39:54 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, peterz@infradead.org, jkosina@suse.cz,
       henne@nachtwindheim.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, peterz@infradead.org, jkosina@suse.cz,
       henne@nachtwindheim.de, tglx@linutronix.de
In-Reply-To: <1269431961-5731-1-git-send-email-henne@nachtwindheim.de>
References: <1269431961-5731-1-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Move two IRQ functions from .init.text to .text
Message-ID: <tip-860652bfb890bd861c999ec39fcffabe5b712f85@git.kernel.org>
Git-Commit-ID: 860652bfb890bd861c999ec39fcffabe5b712f85
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 13:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  860652bfb890bd861c999ec39fcffabe5b712f85
Gitweb:     http://git.kernel.org/tip/860652bfb890bd861c999ec39fcffabe5b712f85
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Wed, 24 Mar 2010 12:59:20 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 24 Mar 2010 14:38:23 +0100

genirq: Move two IRQ functions from .init.text to .text

Both functions should not be marked as __init, since they be called
from modules after the init section is freed.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>
LKML-Reference: <1269431961-5731-1-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 71eba24..3c2d6e7 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -729,7 +729,7 @@ set_irq_chip_and_handler_name(unsigned int irq, struct irq_chip *chip,
 	__set_irq_handler(irq, handle, 0, name);
 }
 
-void __init set_irq_noprobe(unsigned int irq)
+void set_irq_noprobe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -744,7 +744,7 @@ void __init set_irq_noprobe(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
-void __init set_irq_probe(unsigned int irq)
+void set_irq_probe(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
