Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab0HGCRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:17:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37317 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761182Ab0HGCQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:16:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/10] x86, sfi: used smp_register_lapic_address
Date: Fri,  6 Aug 2010 19:15:39 -0700
Message-Id: <1281147343-18389-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
References: <1281147343-18389-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill mp_sfi_register_lapic_address, they are the same

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/sfi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/sfi.c b/arch/x86/kernel/sfi.c
index cb22acf..cfcd5b1 100644
--- a/arch/x86/kernel/sfi.c
+++ b/arch/x86/kernel/sfi.c
@@ -34,17 +34,6 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
-void __init mp_sfi_register_lapic_address(unsigned long address)
-{
-	mp_lapic_addr = address;
-
-	set_fixmap_nocache(FIX_APIC_BASE, mp_lapic_addr);
-	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = read_apic_id();
-
-	pr_info("Boot CPU = %d\n", boot_cpu_physical_apicid);
-}
-
 /* All CPUs enumerated by SFI must be present and enabled */
 void __cpuinit mp_sfi_register_lapic(u8 id)
 {
@@ -110,7 +99,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 int __init sfi_platform_init(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	mp_sfi_register_lapic_address(sfi_lapic_addr);
+	smp_register_lapic_address(sfi_lapic_addr);
 	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
 #endif
 #ifdef CONFIG_X86_IO_APIC
-- 
1.6.4.2

