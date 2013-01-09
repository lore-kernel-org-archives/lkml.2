Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638Ab3AIWGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:06:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14918 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab3AIWGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:06:13 -0500
Message-ID: <1357769168.1800.3.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH v2] ACPI: SRAT: report non-volatile memory in debug
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Jan 2013 14:06:08 -0800
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
 drivers/acpi/numa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/numa.c b/drivers/acpi/numa.c
index cb31298..2935d3a 100644
--- a/drivers/acpi/numa.c
+++ b/drivers/acpi/numa.c
@@ -116,14 +116,16 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
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
 					  (p->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE)?
-					  " hot-pluggable" : ""));
+					  " hot-pluggable" : "",
+					  (p->flags & ACPI_SRAT_MEM_NON_VOLATILE)?
+					  " non-volatile" : ""));
 		}
 #endif				/* ACPI_DEBUG_OUTPUT */
 		break;
-- 
1.7.11.7



