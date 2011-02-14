Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab1BNKA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:00:29 -0500
Received: from server103.greatnet.de ([83.133.97.6]:38321 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1BNKAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:00:24 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@readhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, tj@kernel.org,
        yinghai@kernel.org, ak@linux.intel.com, robert.richter@amd.com,
        linux-kernel@vger.kernel.org, henne@nachtwindheim.de
Subject: [PATCH 4/6] x86: add dummy mp_save_irq()
Date: Mon, 14 Feb 2011 11:00:10 +0100
Message-Id: <1297677612-12405-4-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
References: <1297677612-12405-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmparse.c needs a mp_save_irq() function, which is only available
when CONFIG_X86_IO_APIC is defined. So here we give it a dummy one.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/include/asm/io_apic.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index e1a9b0e..7af0f5f 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -188,6 +188,7 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
+static inline void mp_save_irq(struct mpc_intsrc *m) { }
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
-- 
1.7.2.3

