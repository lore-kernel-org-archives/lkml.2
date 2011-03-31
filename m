Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941Ab1CaSYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:24:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab1CaSYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=YXsKo2zwZfmVg2/Q3K7zYEZgqhdjnSBrjAoH91RyO1TsyoNyZmZlH+eY5bosOf8W/g
         a+y9eWaCdqAn4530VJtp+Ab/QevTG17SotKXe6rANEHaXkh5ji2b23q58CIb2mDeEg2I
         06RaG6b+laqMOn+Cbc/QNKSk36nx3E2YTpmtQ=
MIME-Version: 1.0
Date: Thu, 31 Mar 2011 23:54:50 +0530
Message-ID: <AANLkTincUPbf23QdtQWhqjH+MaB9n2xKWQ4F54sZit=j@mail.gmail.com>
Subject: [PATCH] x86: kernel: acpi : Fix style problems in boot.c
From: Aakash Goenka <aakash.goenka@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        x86@kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Fixes most style errors and warnings.
 Signed-off-by: Aakash Goenka <aakash.goenka@gmail.com>

---
 arch/x86/kernel/acpi/boot.c |   83 +++++++++++++++++++++----------------------
 1 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9a966c5..b9bb13a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -83,7 +83,7 @@ static u64 acpi_lapic_addr __initdata =
APIC_DEFAULT_PHYS_BASE;
 #endif

 /* --------------------------------------------------------------------------
-                              Boot-time Configuration
+				Boot-time Configuration
    --------------------------------------------------------------------------
*/

 /*
@@ -106,11 +106,9 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	unsigned int irq = gsi + NR_IRQS_LEGACY;
 	unsigned int i;

-	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-		if (isa_irq_to_gsi[i] == gsi) {
+	for (i = 0; i < NR_IRQS_LEGACY; i++)
+		if (isa_irq_to_gsi[i] == gsi)
 			return i;
-		}
-	}

 	/* Provide an identity mapping of gsi == irq
 	 * except on truly weird platforms that have
@@ -245,7 +243,7 @@ acpi_parse_x2apic(struct acpi_subtable_header
*header, const unsigned long end)
 }

 static int __init
-acpi_parse_lapic(struct acpi_subtable_header * header, const unsigned long end)
+acpi_parse_lapic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_local_apic *processor = NULL;

@@ -288,7 +286,7 @@ acpi_parse_sapic(struct acpi_subtable_header
*header, const unsigned long end)
 }

 static int __init
-acpi_parse_lapic_addr_ovr(struct acpi_subtable_header * header,
+acpi_parse_lapic_addr_ovr(struct acpi_subtable_header *header,
 			  const unsigned long end)
 {
 	struct acpi_madt_local_apic_override *lapic_addr_ovr = NULL;
@@ -323,7 +321,8 @@ acpi_parse_x2apic_nmi(struct acpi_subtable_header *header,
 }

 static int __init
-acpi_parse_lapic_nmi(struct acpi_subtable_header * header, const
unsigned long end)
+acpi_parse_lapic_nmi(struct acpi_subtable_header *header,
+		     const unsigned long end)
 {
 	struct acpi_madt_local_apic_nmi *lapic_nmi = NULL;

@@ -345,7 +344,7 @@ acpi_parse_lapic_nmi(struct acpi_subtable_header *
header, const unsigned long e
 #ifdef CONFIG_X86_IO_APIC

 static int __init
-acpi_parse_ioapic(struct acpi_subtable_header * header, const
unsigned long end)
+acpi_parse_ioapic(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_io_apic *ioapic = NULL;

@@ -365,7 +364,8 @@ acpi_parse_ioapic(struct acpi_subtable_header *
header, const unsigned long end)
 /*
  * Parse Interrupt Source Override for the ACPI SCI
  */
-static void __init acpi_sci_ioapic_setup(u8 bus_irq, u16 polarity,
u16 trigger, u32 gsi)
+static void __init acpi_sci_ioapic_setup(u8 bus_irq,
+					 u16 polarity, u16 trigger, u32 gsi)
 {
 	if (trigger == 0)	/* compatible SCI trigger is level */
 		trigger = 3;
@@ -396,7 +396,7 @@ static void __init acpi_sci_ioapic_setup(u8
bus_irq, u16 polarity, u16 trigger,
 }

 static int __init
-acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
+acpi_parse_int_src_ovr(struct acpi_subtable_header *header,
 		       const unsigned long end)
 {
 	struct acpi_madt_interrupt_override *intsrc = NULL;
@@ -410,8 +410,10 @@ acpi_parse_int_src_ovr(struct
acpi_subtable_header * header,

 	if (intsrc->source_irq == acpi_gbl_FADT.sci_interrupt) {
 		acpi_sci_ioapic_setup(intsrc->source_irq,
-				      intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
-				      (intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2,
+				      intsrc->inti_flags &
+				      ACPI_MADT_POLARITY_MASK,
+				      (intsrc->inti_flags &
+				      ACPI_MADT_TRIGGER_MASK) >> 2,
 				      intsrc->global_irq);
 		return 0;
 	}
@@ -421,7 +423,8 @@ acpi_parse_int_src_ovr(struct acpi_subtable_header * header,
 			printk(PREFIX "BIOS IRQ0 pin2 override ignored.\n");
 			return 0;
 		}
-		if (acpi_fix_pin2_polarity && (intsrc->inti_flags &
ACPI_MADT_POLARITY_MASK)) {
+		if (acpi_fix_pin2_polarity &&
+		    (intsrc->inti_flags & ACPI_MADT_POLARITY_MASK)) {
 			intsrc->inti_flags &= ~ACPI_MADT_POLARITY_MASK;
 			printk(PREFIX "BIOS IRQ0 pin2 override: forcing polarity to high
active.\n");
 		}
@@ -429,14 +432,16 @@ acpi_parse_int_src_ovr(struct
acpi_subtable_header * header,

 	mp_override_legacy_irq(intsrc->source_irq,
 				intsrc->inti_flags & ACPI_MADT_POLARITY_MASK,
-				(intsrc->inti_flags & ACPI_MADT_TRIGGER_MASK) >> 2,
+				(intsrc->inti_flags &
+				ACPI_MADT_TRIGGER_MASK) >> 2,
 				intsrc->global_irq);

 	return 0;
 }

 static int __init
-acpi_parse_nmi_src(struct acpi_subtable_header * header, const
unsigned long end)
+acpi_parse_nmi_src(struct acpi_subtable_header *header,
+		   const unsigned long end)
 {
 	struct acpi_madt_nmi_source *nmi_src = NULL;

@@ -652,7 +657,7 @@ static int __cpuinit _acpi_map_lsapic(acpi_handle
handle, int *pcpu)
 	 */
 	cpumask_andnot(new_map, cpu_present_mask, tmp_map);
 	if (cpumask_empty(new_map)) {
-		printk ("Unable to map lapic to logical cpu number\n");
+		printk(KERN_WARNING PREFIX "Unable to map lapic to logical cpu number\n");
 		retval = -EINVAL;
 		goto free_new_map;
 	}
@@ -686,9 +691,8 @@ int acpi_unmap_lsapic(int cpu)
 	set_cpu_present(cpu, false);
 	num_processors--;

-	return (0);
+	return 0;
 }
-
 EXPORT_SYMBOL(acpi_unmap_lsapic);
 #endif				/* CONFIG_ACPI_HOTPLUG_CPU */

@@ -697,7 +701,6 @@ int acpi_register_ioapic(acpi_handle handle, u64
phys_addr, u32 gsi_base)
 	/* TBD */
 	return -EINVAL;
 }
-
 EXPORT_SYMBOL(acpi_register_ioapic);

 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
@@ -705,7 +708,6 @@ int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
 	/* TBD */
 	return -EINVAL;
 }
-
 EXPORT_SYMBOL(acpi_unregister_ioapic);

 static int __init acpi_parse_sbf(struct acpi_table_header *table)
@@ -726,7 +728,7 @@ static int __init acpi_parse_sbf(struct
acpi_table_header *table)
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>

-static struct __initdata resource *hpet_res;
+static struct __initdata resource * hpet_res;

 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
@@ -833,7 +835,7 @@ static int __init acpi_parse_fadt(struct
acpi_table_header *table)
 		 * "X" fields are optional extensions to the original V1.0
 		 * fields, so we must selectively expand V1.0 fields if the
 		 * corresponding X field is zero.
-	 	 */
+		 */
 		if (!pmtmr_ioport)
 			pmtmr_ioport = acpi_gbl_FADT.pm_timer_block;
 	} else {
@@ -926,7 +928,8 @@ static int __init acpi_parse_madt_lapic_entries(void)
 	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
 				  acpi_parse_x2apic_nmi, 0);
 	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
acpi_parse_lapic_nmi, 0);
+	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI,
+				  acpi_parse_lapic_nmi, 0);
 	if (count < 0 || x2count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
@@ -983,7 +986,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	struct mpc_intsrc mp_irq;

-#if defined (CONFIG_MCA) || defined (CONFIG_EISA)
+#if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 	/*
 	 * Fabricate the legacy ISA bus (bus #31).
 	 */
@@ -1170,8 +1173,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	}

 	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
acpi_parse_int_src_ovr,
-				  nr_irqs);
+	    acpi_table_parse_madt(ACPI_MADT_TYPE_INTERRUPT_OVERRIDE,
+				  acpi_parse_int_src_ovr, nr_irqs);
 	if (count < 0) {
 		printk(KERN_ERR PREFIX
 		       "Error parsing interrupt source overrides entry\n");
@@ -1269,10 +1272,10 @@ static void __init acpi_process_madt(void)
 		}
 	} else {
 		/*
- 		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
- 		 * In the event an MPS table was found, forget it.
- 		 * Boot with "acpi=off" to use MPS on such a system.
- 		 */
+		 * ACPI found no MADT, and so ACPI wants UP PIC mode.
+		 * In the event an MPS table was found, forget it.
+		 * Boot with "acpi=off" to use MPS on such a system.
+		 */
 		if (smp_found_config) {
 			printk(KERN_WARNING PREFIX
 				"No APIC-table, disabling MPS\n");
@@ -1496,7 +1499,7 @@ void __init acpi_boot_table_init(void)
 	 * If acpi_disabled, bail out
 	 */
 	if (acpi_disabled)
-		return;
+		return;

 	/*
 	 * Initialize the ACPI boot-time table parser.
@@ -1575,26 +1578,22 @@ static int __init parse_acpi(char *arg)
 		return -EINVAL;

 	/* "acpi=off" disables both ACPI table parsing and interpreter */
-	if (strcmp(arg, "off") == 0) {
+	if (strcmp(arg, "off") == 0)
 		disable_acpi();
-	}
 	/* acpi=force to over-ride black-list */
 	else if (strcmp(arg, "force") == 0) {
 		acpi_force = 1;
 		acpi_disabled = 0;
 	}
 	/* acpi=strict disables out-of-spec workarounds */
-	else if (strcmp(arg, "strict") == 0) {
+	else if (strcmp(arg, "strict") == 0)
 		acpi_strict = 1;
-	}
 	/* acpi=rsdt use RSDT instead of XSDT */
-	else if (strcmp(arg, "rsdt") == 0) {
+	else if (strcmp(arg, "rsdt") == 0)
 		acpi_rsdt_forced = 1;
-	}
 	/* "acpi=noirq" disables ACPI interrupt routing */
-	else if (strcmp(arg, "noirq") == 0) {
+	else if (strcmp(arg, "noirq") == 0)
 		acpi_noirq_set();
-	}
 	/* "acpi=copy_dsdt" copys DSDT */
 	else if (strcmp(arg, "copy_dsdt") == 0) {
 		acpi_gbl_copy_dsdt_locally = 1;
@@ -1674,7 +1673,7 @@ int __acpi_acquire_global_lock(unsigned int *lock)
 		old = *lock;
 		new = (((old & ~0x3) + 2) + ((old >> 1) & 0x1));
 		val = cmpxchg(lock, old, new);
-	} while (unlikely (val != old));
+	} while (unlikely(val != old));
 	return (new < 3) ? -1 : 0;
 }

@@ -1685,6 +1684,6 @@ int __acpi_release_global_lock(unsigned int *lock)
 		old = *lock;
 		new = old & ~0x3;
 		val = cmpxchg(lock, old, new);
-	} while (unlikely (val != old));
+	} while (unlikely(val != old));
 	return old & 0x1;
 }
-- 
1.7.0.4
