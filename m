Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1BWMHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:07:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:56570 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1BWMHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:07:52 -0500
Date: Wed, 23 Feb 2011 12:07:17 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, henne@nachtwindheim.de, mingo@elte.hu
In-Reply-To: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
References: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: Move ioapic_irq_destination_types to apicdef.h
Message-ID: <tip-4e034b245133adfd006ade5d7a809c9cac4beef9@git.kernel.org>
Git-Commit-ID: 4e034b245133adfd006ade5d7a809c9cac4beef9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 12:07:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4e034b245133adfd006ade5d7a809c9cac4beef9
Gitweb:     http://git.kernel.org/tip/4e034b245133adfd006ade5d7a809c9cac4beef9
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Tue, 22 Feb 2011 15:38:03 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 23 Feb 2011 11:38:44 +0100

x86: Move ioapic_irq_destination_types to apicdef.h

This enum is used by non IOAPIC code, so apicdef.h is
the best place for it.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
LKML-Reference: <1298385487-4708-1-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
