Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0K2BGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 20:06:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65138 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0K2BGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 20:06:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=QNCj/Gk+EHjaZemQFLip7wHxJvxFbrgOOLM/N7Rr8NVWY2p59gleMI1iNMSyQr2Sue
         9VS79H7WY7KJ7Y/uV3PqsL0U7ErqZkn9/86NL6i2Q2yj10xYrZXS0x8fcQDAxtR4CX/D
         FJ58g82NpLqqG9moaVWK5i+/Opbrp3/iDs7EA=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] apic/io_apic.c: Move variable 'desc' into the #ifdef.
Date: Sun, 28 Nov 2010 23:06:20 -0200
Message-Id: <4cc988bf535efac7a6aafe1ca0f0ac44f3968d94.1290992687.git.tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is only used in the presence of the CONFIG_GENERIC_PENDING_IRQ.
So when compiling without this config, we get the following warning:

arch/x86/kernel/apic/io_apic.c: In function ‘ack_apic_level’:
arch/x86/kernel/apic/io_apic.c:2433: warning: unused variable ‘desc’

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..56261be 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2430,9 +2430,12 @@ static void ack_apic_level(struct irq_data *data)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	int i, do_unmask_irq = 0, irq = data->irq;
-	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long v;
 
+#ifdef CONFIG_GENERIC_PENDING_IRQ
+	struct irq_desc *desc = irq_to_desc(irq);
+#endif
+
 	irq_complete_move(cfg);
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	/* If we are moving the irq we need to mask it */
-- 
1.7.3.2.343.g7d43d

