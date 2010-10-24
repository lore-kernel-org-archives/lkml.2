Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab0JXBEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 21:04:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48155 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930Ab0JXBEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 21:04:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/15] x86, apic: Use smp_register_lapic_address in init_apic_mapping
Date: Sat, 23 Oct 2010 18:02:20 -0700
Message-Id: <1287882149-29275-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
References: <1287882149-29275-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So if set_fixmap_nocache is not called, don't print out anything

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/apic/apic.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 05b8bf7..a5ce130 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1656,10 +1656,7 @@ void __init init_apic_mappings(void)
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
1.7.1

