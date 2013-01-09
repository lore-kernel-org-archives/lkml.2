Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3AIAQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:16:00 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:13146 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3AIAP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:15:58 -0500
Message-ID: <1357690556.1890.13.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] ACPI: SRAT: report non-volatile memory in debug
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2013 16:15:56 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just as with the other memory affinity flags, report
non-volatile memory with ACPI debug.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 drivers/acpi/numa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index cb31298..68077ac 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -116,12 +116,14 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 			struct acpi_srat_mem_affinity *p =
 			    (struct acpi_srat_mem_affinity *)header;
 			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s\n",
+					  "SRAT Memory (0x%lx length 0x%lx) in proximity domain %d %s%s%s\n",
 					  (unsigned long)p->base_address,
 					  (unsigned long)p->length,
 					  p->proximity_domain,
 					  (p->flags & ACPI_SRAT_MEM_ENABLED)?
 					  "enabled" : "disabled",
+					  (p->flags & ACPI_SRAT_MEM_NON_VOLATILE)?
+					  " non-volatile" : "",
 					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
 					  " hot-pluggable" : ""));
 		}
-- 
1.7.11.7



