Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab0LGI47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:56:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22711 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab0LGI4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:56:49 -0500
Message-ID: <4CFDF693.6000908@kernel.org>
Date: Tue, 07 Dec 2010 00:55:47 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] x86, sfi: Use register_lapic_address()
References: <4CFDF544.8020309@kernel.org>
In-Reply-To: <4CFDF544.8020309@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kill mp_sfi_register_lapic_address, they are the same

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/platform/sfi/sfi.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

Index: linux-2.6/arch/x86/platform/sfi/sfi.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/sfi/sfi.c
+++ linux-2.6/arch/x86/platform/sfi/sfi.c
@@ -34,17 +34,6 @@
 #ifdef CONFIG_X86_LOCAL_APIC
 static unsigned long sfi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 
-static void __init mp_sfi_register_lapic_address(unsigned long address)
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
 static void __cpuinit mp_sfi_register_lapic(u8 id)
 {
@@ -110,7 +99,7 @@ static int __init sfi_parse_ioapic(struc
 int __init sfi_platform_init(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	mp_sfi_register_lapic_address(sfi_lapic_addr);
+	register_lapic_address(sfi_lapic_addr);
 	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
 #endif
 #ifdef CONFIG_X86_IO_APIC
