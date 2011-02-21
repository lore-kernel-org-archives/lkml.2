Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1BUI7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 03:59:34 -0500
Received: from server103.greatnet.de ([83.133.97.6]:44037 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1BUI7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 03:59:32 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 1/5] x86: move ioapic_irq_destination_types to apicdef.h
Date: Mon, 21 Feb 2011 09:59:20 +0100
Message-Id: <1298278764-3320-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enum is used by non IOAPIC code, so apicdef.h is
the best place for it.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/apicdef.h |   12 ++++++++++++
 arch/x86/include/asm/io_apic.h |   11 -----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 47a30ff..d87988b 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -426,4 +426,16 @@ struct local_apic {
 #else
  #define BAD_APICID 0xFFFFu
 #endif
+
+enum ioapic_irq_destination_types {
+	dest_Fixed		= 0,
+	dest_LowestPrio		= 1,
+	dest_SMI		= 2,
+	dest__reserved_1	= 3,
+	dest_NMI		= 4,
+	dest_INIT		= 5,
+	dest__reserved_2	= 6,
+	dest_ExtINT		= 7
+};
+
 #endif /* _ASM_X86_APICDEF_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index f327d38..e1a9b0e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -63,17 +63,6 @@ union IO_APIC_reg_03 {
 	} __attribute__ ((packed)) bits;
 };
 
-enum ioapic_irq_destination_types {
-	dest_Fixed = 0,
-	dest_LowestPrio = 1,
-	dest_SMI = 2,
-	dest__reserved_1 = 3,
-	dest_NMI = 4,
-	dest_INIT = 5,
-	dest__reserved_2 = 6,
-	dest_ExtINT = 7
-};
-
 struct IO_APIC_route_entry {
 	__u32	vector		:  8,
 		delivery_mode	:  3,	/* 000: FIXED
-- 
1.7.2.3

