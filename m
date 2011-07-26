Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab1GZO2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:28:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:52187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab1GZO2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:28:03 -0400
Date: Tue, 26 Jul 2011 14:27:54 GMT
From: "tip-bot for jhbird.choi@samsung.com" <jhbird.choi@samsung.com>
Message-ID: <tip-1dd75f91ae713049eb6baaa640078f3a6549e522@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, jhbird.choi@samsung.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jhbird.choi@samsung.com
In-Reply-To: <1311229754-6003-1-git-send-email-jhbird.choi@samsung.com>
References: <1311229754-6003-1-git-send-email-jhbird.choi@samsung.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/urgent] genirq: Fix wrong bit operation
Git-Commit-ID: 1dd75f91ae713049eb6baaa640078f3a6549e522
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Jul 2011 14:27:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dd75f91ae713049eb6baaa640078f3a6549e522
Gitweb:     http://git.kernel.org/tip/1dd75f91ae713049eb6baaa640078f3a6549e522
Author:     jhbird.choi@samsung.com <jhbird.choi@samsung.com>
AuthorDate: Thu, 21 Jul 2011 15:29:14 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 26 Jul 2011 16:24:02 +0200

genirq: Fix wrong bit operation

(!msk & 0x01) should be !(msk & 0x01)

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Link: http://lkml.kernel.org/r/1311229754-6003-1-git-send-email-jhbird.choi@samsung.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 kernel/irq/generic-chip.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 3a2cab4..e38544d 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -246,7 +246,7 @@ void irq_setup_generic_chip(struct irq_chip_generic *gc, u32 msk,
 		gc->mask_cache = irq_reg_readl(gc->reg_base + ct->regs.mask);
 
 	for (i = gc->irq_base; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		if (flags & IRQ_GC_INIT_NESTED_LOCK)
@@ -301,7 +301,7 @@ void irq_remove_generic_chip(struct irq_chip_generic *gc, u32 msk,
 	raw_spin_unlock(&gc_lock);
 
 	for (; msk; msk >>= 1, i++) {
-		if (!msk & 0x01)
+		if (!(msk & 0x01))
 			continue;
 
 		/* Remove handler first. That will mask the irq line */
