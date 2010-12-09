Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab0LIU4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:56:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:52006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab0LIU4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:56:04 -0500
Date: Thu, 9 Dec 2010 20:55:49 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, ebiederm@xmission.com, lenb@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        lenb@kernel.org, yinghai@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, ebiederm@xmission.com
In-Reply-To: <4CFDF693.6000908@kernel.org>
References: <4CFDF693.6000908@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic-cleanups] x86, sfi: Use register_lapic_address()
Message-ID: <tip-53301f36f316a6519c464b0ef2a155386c20be19@git.kernel.org>
Git-Commit-ID: 53301f36f316a6519c464b0ef2a155386c20be19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Dec 2010 20:55:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53301f36f316a6519c464b0ef2a155386c20be19
Gitweb:     http://git.kernel.org/tip/53301f36f316a6519c464b0ef2a155386c20be19
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 7 Dec 2010 00:55:47 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Dec 2010 21:52:05 +0100

x86, sfi: Use register_lapic_address()

register_lapic_address() and mp_sfi_register_lapic_address() are
almost identical. Use the common function.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Len Brown <lenb@kernel.org>
LKML-Reference: <4CFDF693.6000908@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/platform/sfi/sfi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index dd4c281..cc822a2 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
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
@@ -110,7 +99,7 @@ static int __init sfi_parse_ioapic(struct sfi_table_header *table)
 int __init sfi_platform_init(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	mp_sfi_register_lapic_address(sfi_lapic_addr);
+	register_lapic_address(sfi_lapic_addr);
 	sfi_table_parse(SFI_SIG_CPUS, NULL, NULL, sfi_parse_cpus);
 #endif
 #ifdef CONFIG_X86_IO_APIC
