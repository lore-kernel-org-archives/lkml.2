Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab1DJGQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 02:16:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44306 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1DJGQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 02:16:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KulU3vxAHFtT9rR/FauI3watY7rA7UuzVcc6N85mUZaa0zKJx2MUHR9hrIohX/b2qi
         fPXL8Gkmvavo8L5XFhCno1VBbWjPJf+euRjF4Pw+9mRk1wsZtCyC6/86W42vhzp103iD
         1a0mhj9FHEK7EZAoeLPH+Xu+87KDkmHSp2PYo=
From: wanlong.gao@gmail.com
To: hans-christian.egtvedt@atmel.com, chris@zankel.net, steiner@sgi.com,
        tglx@linutronix.de, akpm@linux-foundation.org, hch@lst.de
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 2/3] fix the wrong argument of the functions definition
Date: Sun, 10 Apr 2011 14:14:43 +0800
Message-Id: <1302416084-13372-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
References: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

The functions of eic_chip's memebers use the wrong argument .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/avr32/mach-at32ap/extint.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index 47ba4b9..755ac59
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -61,34 +61,34 @@ struct eic {
 static struct eic *nmi_eic;
 static bool nmi_enabled;
 
-static void eic_ack_irq(struct irq_chip *d)
+static void eic_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_irq(struct irq_chip *d)
+static void eic_mask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_mask_ack_irq(struct irq_chip *d)
+static void eic_mask_ack_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, ICR, 1 << (d->irq - eic->first_irq));
 	eic_writel(eic, IDR, 1 << (d->irq - eic->first_irq));
 }
 
-static void eic_unmask_irq(struct irq_chip *d)
+static void eic_unmask_irq(struct irq_data *d)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	eic_writel(eic, IER, 1 << (d->irq - eic->first_irq));
 }
 
-static int eic_set_irq_type(struct irq_chip *d, unsigned int flow_type)
+static int eic_set_irq_type(struct irq_data *d, unsigned int flow_type)
 {
-	struct eic *eic = irq_data_get_irq_chip_data(data);
+	struct eic *eic = irq_data_get_irq_chip_data(d);
 	unsigned int irq = d->irq;
 	unsigned int i = irq - eic->first_irq;
 	u32 mode, edge, level;
-- 
1.7.3

