Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0LGI44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:56:56 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22690 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0LGI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:56:47 -0500
Message-ID: <4CFDF68A.7020902@kernel.org>
Date: Tue, 07 Dec 2010 00:55:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] x86, apic: Use register_lapic_address in init_apic_mapping
References: <4CFDF544.8020309@kernel.org>
In-Reply-To: <4CFDF544.8020309@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So if nothing is changed, don't print out anything

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1650,10 +1650,7 @@ void __init init_apic_mappings(void)
 		 * acpi_register_lapic_address()
 		 */
 		if (!acpi_lapic && !smp_found_config)
-			set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
-
-		apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
-					APIC_BASE, apic_phys);
+			register_lapic_address(apic_phys);
 	}
 
 	/*
