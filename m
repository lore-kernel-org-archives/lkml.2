Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2DQUhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:37:34 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2DQUhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:37:31 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] um: Remove usage of irq_chip->release()
Date: Tue, 17 Apr 2012 22:37:14 +0200
Message-Id: <1334695036-19977-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1334695036-19977-1-git-send-email-richard@nod.at>
References: <1334695036-19977-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UML does no longer need irq_chip->release().

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/kernel/irq.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/irq.c b/arch/um/kernel/irq.c
index 47a09ee..00506c3 100644
--- a/arch/um/kernel/irq.c
+++ b/arch/um/kernel/irq.c
@@ -334,7 +334,6 @@ static void dummy(struct irq_data *d)
 /* This is used for everything else than the timer. */
 static struct irq_chip normal_irq_type = {
 	.name = "SIGIO",
-	.release = free_irq_by_irq_and_dev,
 	.irq_disable = dummy,
 	.irq_enable = dummy,
 	.irq_ack = dummy,
@@ -342,7 +341,6 @@ static struct irq_chip normal_irq_type = {
 
 static struct irq_chip SIGVTALRM_irq_type = {
 	.name = "SIGVTALRM",
-	.release = free_irq_by_irq_and_dev,
 	.irq_disable = dummy,
 	.irq_enable = dummy,
 	.irq_ack = dummy,
-- 
1.7.7.3

