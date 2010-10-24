Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab0JXBEt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48144 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab0JXBEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:47 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 14/15] acpi: Reverse uid and apic_id print out for x2apic
Date: Sat, 23 Oct 2010 18:02:28 -0700
Message-Id: <1287882149-29275-15-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So make it have same sequence like old apic.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/tables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index 3e4a60e..4dffce0 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -67,8 +67,8 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
 			struct acpi_madt_local_x2apic *p =
 			    (struct acpi_madt_local_x2apic *)header;
 			printk(KERN_INFO PREFIX
-			       "X2APIC (apic_id[0x%02x] uid[0x%02x] %s)\n",
-			       p->local_apic_id, p->uid,
+			       "X2APIC (uid[0x%02x] apic_id[0x%02x] %s)\n",
+			       p->uid, p->local_apic_id,
 			       (p->lapic_flags & ACPI_MADT_ENABLED) ?
 			       "enabled" : "disabled");
 		}
-- 
1.7.1

