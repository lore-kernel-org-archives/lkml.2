Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab1CUMGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 08:06:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36433 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751783Ab1CUMG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 08:06:29 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX19Z4TItbjtZaS46y5XgIYMrhQoxkBcSEU1e6OfnKD
	5FMdfaMk5bjtY1
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linuxpps@ml.enneenne.com,
        Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 2/5] RFC genirq: add function to retrieve timestamp from irqdesc
Date: Mon, 21 Mar 2011 12:59:17 +0100
Message-Id: <1300708760-27910-2-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
References: <1300708760-27910-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is probably not useful.
and will be superceded by other functions.
its just here to ilustrate my initial idea.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 kernel/irq/manage.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e9df1f0..adbf6c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1176,3 +1176,12 @@ int request_any_context_irq(unsigned int irq, irq_handler_t handler,
 	return !ret ? IRQC_IS_HARDIRQ : ret;
 }
 EXPORT_SYMBOL_GPL(request_any_context_irq);
+
+void retreive_irq_timestamp(unsigned int irq, struct timespec *ts)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	*ts = desc->last_timestamp;
+}
+EXPORT_SYMBOL_GPL(retreive_irq_timestamp);
+
-- 
1.7.2.3

