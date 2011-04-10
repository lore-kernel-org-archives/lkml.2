Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1DJGPr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 02:15:47 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:39372 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1DJGPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 02:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EcUHoaBjK6mh3XUX0IEqgF3xLTR1TRIAQSFpdbZm4XLnfl8MX5EJ1qPdIGXeo5774g
         sQBOkH3B5fiOuk5pWvgaG8pFZZwF7QWlWG7KWo7kyiBClRgM23POMsp2urammcZh9nkG
         dEwuXE+fgE48QIrTu6I/FGdQFXJxpPXskjInQ=
From: wanlong.gao@gmail.com
To: hans-christian.egtvedt@atmel.com, chris@zankel.net, steiner@sgi.com,
        tglx@linutronix.de, akpm@linux-foundation.org, hch@lst.de
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 1/3] fix the argument error of irq_chip's members
Date: Sun, 10 Apr 2011 14:14:42 +0800
Message-Id: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

The functions of xtensa_irq_chip members use the wrong argument.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/xtensa/kernel/irq.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/kernel/irq.c b/arch/xtensa/kernel/irq.c
index d77089d..e47c2a9
--- a/arch/xtensa/kernel/irq.c
+++ b/arch/xtensa/kernel/irq.c
@@ -75,36 +75,36 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 	return 0;
 }
 
-static void xtensa_irq_mask(struct irq_chip *d)
+static void xtensa_irq_mask(struct irq_data *d)
 {
 	cached_irq_mask &= ~(1 << d->irq);
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_unmask(struct irq_chip *d)
+static void xtensa_irq_unmask(struct irq_data *d)
 {
 	cached_irq_mask |= 1 << d->irq;
 	set_sr (cached_irq_mask, INTENABLE);
 }
 
-static void xtensa_irq_enable(struct irq_chip *d)
+static void xtensa_irq_enable(struct irq_data *d)
 {
 	variant_irq_enable(d->irq);
 	xtensa_irq_unmask(d->irq);
 }
 
-static void xtensa_irq_disable(struct irq_chip *d)
+static void xtensa_irq_disable(struct irq_data *d)
 {
 	xtensa_irq_mask(d->irq);
 	variant_irq_disable(d->irq);
 }
 
-static void xtensa_irq_ack(struct irq_chip *d)
+static void xtensa_irq_ack(struct irq_data *d)
 {
 	set_sr(1 << d->irq, INTCLEAR);
 }
 
-static int xtensa_irq_retrigger(struct irq_chip *d)
+static int xtensa_irq_retrigger(struct irq_data *d)
 {
 	set_sr (1 << d->irq, INTSET);
 	return 1;
-- 
1.7.3

