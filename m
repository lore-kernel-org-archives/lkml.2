Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab1EVKoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:44:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:52686 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab1EVKoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:44:30 -0400
Date: Sun, 22 May 2011 10:44:18 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-1a8880a14270814dae0d226a2ad065d30587e60a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110521005526.341718626@sbsiddha-MOBL3.sc.intel.com>
References: <20110521005526.341718626@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Make apic drivers static
Git-Commit-ID: 1a8880a14270814dae0d226a2ad065d30587e60a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 22 May 2011 10:44:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a8880a14270814dae0d226a2ad065d30587e60a
Gitweb:     http://git.kernel.org/tip/1a8880a14270814dae0d226a2ad065d30587e60a
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 20 May 2011 17:51:20 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 22 May 2011 11:48:04 +0200

x86, apic: Make apic drivers static

Apic probe now looks at the apic drivers listed in the
.apicdrivers section. Remove apic_probe[] and make each apic
driver static.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: steiner@sgi.com
Cc: gorcunov@openvz.org
Cc: yinghai@kernel.org
Link: http://lkml.kernel.org/r/20110521005526.341718626@sbsiddha-MOBL3.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apic.h           |    7 -------
 arch/x86/kernel/apic/apic_flat_64.c   |   10 ++++++++--
 arch/x86/kernel/apic/bigsmp_32.c      |    2 +-
 arch/x86/kernel/apic/es7000_32.c      |    4 ++--
 arch/x86/kernel/apic/numaq_32.c       |    4 ++--
 arch/x86/kernel/apic/probe_32.c       |   26 +-------------------------
 arch/x86/kernel/apic/probe_64.c       |   21 ---------------------
 arch/x86/kernel/apic/summit_32.c      |    2 +-
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 arch/x86/kernel/apic/x2apic_phys.c    |    4 +++-
 arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +++-
 11 files changed, 22 insertions(+), 64 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f37703d..4a0b7c7 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -478,15 +478,10 @@ static inline unsigned default_get_apic_id(unsigned long x)
 #define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2apic_cluster;
-extern struct apic apic_x2apic_phys;
 extern int default_acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
 
-extern struct apic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern int default_cpu_present_to_apicid(int mps_cpu);
@@ -536,8 +531,6 @@ extern struct apic apic_noop;
 
 #ifdef CONFIG_X86_32
 
-extern struct apic apic_default;
-
 static inline int noop_x86_32_early_logical_apicid(int cpu)
 {
 	return BAD_APICID;
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 6ce0f7f..9570ee5 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -24,6 +24,12 @@
 #include <acpi/acpi_bus.h>
 #endif
 
+static struct apic apic_physflat;
+static struct apic apic_flat;
+
+struct apic __read_mostly *apic = &apic_flat;
+EXPORT_SYMBOL_GPL(apic);
+
 static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
@@ -164,7 +170,7 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-struct apic apic_flat =  {
+static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
@@ -320,7 +326,7 @@ static int physflat_probe(void)
 	return 0;
 }
 
-struct apic apic_physflat =  {
+static struct apic apic_physflat =  {
 
 	.name				= "physical flat",
 	.probe				= physflat_probe,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 479a06c..efd737e 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -193,7 +193,7 @@ static int probe_bigsmp(void)
 	return dmi_bigsmp;
 }
 
-struct apic apic_bigsmp = {
+static struct apic apic_bigsmp = {
 
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 80de0d7..9536b3f 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -620,7 +620,7 @@ static int es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem,
 }
 
 /* We've been warned by a false positive warning.Use __refdata to keep calm. */
-struct apic __refdata apic_es7000_cluster = {
+static struct apic __refdata apic_es7000_cluster = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
@@ -685,7 +685,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
 
-struct apic __refdata apic_es7000 = {
+static struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 4caab0d..c4a61ca 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -472,8 +472,8 @@ static void numaq_setup_portio_remap(void)
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-/* Use __refdata to keep false positive warning calm.	*/
-struct apic __refdata apic_numaq = {
+/* Use __refdata to keep false positive warning calm.  */
+static struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index c81756d..b5254ad 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -87,7 +87,7 @@ static int probe_default(void)
 	return 1;
 }
 
-struct apic apic_default = {
+static struct apic apic_default = {
 
 	.name				= "default",
 	.probe				= probe_default,
@@ -151,33 +151,9 @@ struct apic apic_default = {
 
 apic_driver(apic_default);
 
-extern struct apic apic_numaq;
-extern struct apic apic_summit;
-extern struct apic apic_bigsmp;
-extern struct apic apic_es7000;
-extern struct apic apic_es7000_cluster;
-
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
 
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_NUMAQ
-	&apic_numaq,
-#endif
-#ifdef CONFIG_X86_SUMMIT
-	&apic_summit,
-#endif
-#ifdef CONFIG_X86_BIGSMP
-	&apic_bigsmp,
-#endif
-#ifdef CONFIG_X86_ES7000
-	&apic_es7000,
-	&apic_es7000_cluster,
-#endif
-	&apic_default,	/* must be last */
-	NULL,
-};
-
 static int cmdline_apic __initdata;
 static int __init parse_apic(char *arg)
 {
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index e2c361d..3fe9866 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -23,27 +23,6 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2xpic_uv_x;
-extern struct apic apic_x2apic_phys;
-extern struct apic apic_x2apic_cluster;
-
-struct apic __read_mostly *apic = &apic_flat;
-EXPORT_SYMBOL_GPL(apic);
-
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_UV
-	&apic_x2apic_uv_x,
-#endif
-#ifdef CONFIG_X86_X2APIC
-	&apic_x2apic_phys,
-	&apic_x2apic_cluster,
-#endif
-	&apic_physflat,
-	NULL,
-};
-
 static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 447ec0f..1911442 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -491,7 +491,7 @@ void setup_summit(void)
 }
 #endif
 
-struct apic apic_summit = {
+static struct apic apic_summit = {
 
 	.name				= "summit",
 	.probe				= probe_summit,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 7595c57..5007958 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -208,7 +208,7 @@ static int x2apic_cluster_probe(void)
 		return 0;
 }
 
-struct apic apic_x2apic_cluster = {
+static struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
 	.probe				= x2apic_cluster_probe,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index f7ba21c..f5373df 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -11,6 +11,8 @@
 
 int x2apic_phys;
 
+static struct apic apic_x2apic_phys;
+
 static int set_x2apic_phys_mode(char *arg)
 {
 	x2apic_phys = 1;
@@ -112,7 +114,7 @@ static int x2apic_phys_probe(void)
 	return apic == &apic_x2apic_phys;
 }
 
-struct apic apic_x2apic_phys = {
+static struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
 	.probe				= x2apic_phys_probe,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index b6c6298..f450b68 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -58,6 +58,8 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+static struct apic apic_x2apic_uv_x;
+
 static unsigned long __init uv_early_read_mmr(unsigned long addr)
 {
 	unsigned long val, *mmr;
@@ -331,7 +333,7 @@ static int uv_probe(void)
 	return apic == &apic_x2apic_uv_x;
 }
 
-struct apic __refdata apic_x2apic_uv_x = {
+static struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= uv_probe,
