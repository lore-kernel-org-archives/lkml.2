Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0HGCQc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:16:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37207 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0HGCQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:16:28 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/10] x86, apic: use smp_register_lapic_address in init_apic_mapping
Date: Fri,  6 Aug 2010 19:15:38 -0700
Message-Id: <1281147343-18389-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so if set_fixmap_nocache is not called, don't print out anything

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 95a31b1..3d3d3da 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1585,10 +1585,7 @@ void __init init_apic_mappings(void)
 		 * acpi_register_lapic_address()
 		 */
 		if (!acpi_lapic)
-			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-
-		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-					APIC_BASE, apic_phys);
+			smp_register_lapic_address(apic_phys);
 	}
 
 	/*
-- 
1.6.4.2

