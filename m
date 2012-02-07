Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2BGTmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:42:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40867 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2BGTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:42:47 -0500
Date: Tue, 7 Feb 2012 11:42:31 -0800
From: tip-bot for Michael D Labriola <michael.d.labriola@gmail.com>
Message-ID: <tip-lde9yy7qsomh0sdqevn7xp56@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        michael.d.labriola@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        michael.d.labriola@gmail.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86/reboot: Clean up coding style
Git-Commit-ID: 144d102b926f887d3d9f909b69a5c4f504ae0d40
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:42:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  144d102b926f887d3d9f909b69a5c4f504ae0d40
Gitweb:     http://git.kernel.org/tip/144d102b926f887d3d9f909b69a5c4f504ae0d40
Author:     Michael D Labriola <michael.d.labriola@gmail.com>
AuthorDate: Wed, 1 Feb 2012 10:06:34 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Feb 2012 11:34:12 +0100

x86/reboot: Clean up coding style

This commit simply cleans up the style used in this file to fall
in line with what's specified in CodingStyle.  Mostly comment
changes, with a single removal of unneeded braces.

Note that the comments for all the DMI quirks in
reboot_dmi_table now all line up consistently using tabs instead
of spaces.

Signed-off-by: Michael D Labriola <michael.d.labriola@gmail.com>
Link: http://lkml.kernel.org/n/tip-lde9yy7qsomh0sdqevn7xp56@git.kernel.org
[ Fixed a few small details. ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/reboot.c |  129 +++++++++++++++++++++++++---------------------
 1 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e739737..77215c2 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -39,7 +39,8 @@ static int reboot_mode;
 enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
-/* This variable is used privately to keep track of whether or not
+/*
+ * This variable is used privately to keep track of whether or not
  * reboot_type is still set to its default value (i.e., reboot= hasn't
  * been set on the command line).  This is needed so that we can
  * suppress DMI scanning for reboot quirks.  Without it, it's
@@ -51,7 +52,8 @@ static int reboot_default = 1;
 static int reboot_cpu = -1;
 #endif
 
-/* This is set if we need to go through the 'emergency' path.
+/*
+ * This is set if we need to go through the 'emergency' path.
  * When machine_emergency_restart() is called, we may be on
  * an inconsistent state and won't be able to do a clean cleanup
  */
@@ -60,22 +62,24 @@ static int reboot_emergency;
 /* This is set by the PCI code if either type 1 or type 2 PCI is detected */
 bool port_cf9_safe = false;
 
-/* reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
-   warm   Don't set the cold reboot flag
-   cold   Set the cold reboot flag
-   bios   Reboot by jumping through the BIOS (only for X86_32)
-   smp    Reboot by executing reset on BSP or other CPU (only for X86_32)
-   triple Force a triple fault (init)
-   kbd    Use the keyboard controller. cold reset (default)
-   acpi   Use the RESET_REG in the FADT
-   efi    Use efi reset_system runtime service
-   pci    Use the so-called "PCI reset register", CF9
-   force  Avoid anything that could hang.
+/*
+ * reboot=b[ios] | s[mp] | t[riple] | k[bd] | e[fi] [, [w]arm | [c]old] | p[ci]
+ * warm   Don't set the cold reboot flag
+ * cold   Set the cold reboot flag
+ * bios   Reboot by jumping through the BIOS (only for X86_32)
+ * smp    Reboot by executing reset on BSP or other CPU (only for X86_32)
+ * triple Force a triple fault (init)
+ * kbd    Use the keyboard controller. cold reset (default)
+ * acpi   Use the RESET_REG in the FADT
+ * efi    Use efi reset_system runtime service
+ * pci    Use the so-called "PCI reset register", CF9
+ * force  Avoid anything that could hang.
  */
 static int __init reboot_setup(char *str)
 {
 	for (;;) {
-		/* Having anything passed on the command line via
+		/*
+		 * Having anything passed on the command line via
 		 * reboot= will cause us to disable DMI checking
 		 * below.
 		 */
@@ -98,9 +102,11 @@ static int __init reboot_setup(char *str)
 				if (isdigit(*(str+2)))
 					reboot_cpu = reboot_cpu*10 + (int)(*(str+2) - '0');
 			}
-				/* we will leave sorting out the final value
-				   when we are ready to reboot, since we might not
-				   have detected BSP APIC ID or smp_num_cpu */
+			/*
+			 * We will leave sorting out the final value
+			 * when we are ready to reboot, since we might not
+			 * have detected BSP APIC ID or smp_num_cpu
+			 */
 			break;
 #endif /* CONFIG_SMP */
 
@@ -162,14 +168,15 @@ void machine_real_restart(unsigned int type)
 
 	local_irq_disable();
 
-	/* Write zero to CMOS register number 0x0f, which the BIOS POST
-	   routine will recognize as telling it to do a proper reboot.  (Well
-	   that's what this book in front of me says -- it may only apply to
-	   the Phoenix BIOS though, it's not clear).  At the same time,
-	   disable NMIs by setting the top bit in the CMOS address register,
-	   as we're about to do peculiar things to the CPU.  I'm not sure if
-	   `outb_p' is needed instead of just `outb'.  Use it to be on the
-	   safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
+	/*
+	 * Write zero to CMOS register number 0x0f, which the BIOS POST
+	 * routine will recognize as telling it to do a proper reboot.  (Well
+	 * that's what this book in front of me says -- it may only apply to
+	 * the Phoenix BIOS though, it's not clear).  At the same time,
+	 * disable NMIs by setting the top bit in the CMOS address register,
+	 * as we're about to do peculiar things to the CPU.  I'm not sure if
+	 * `outb_p' is needed instead of just `outb'.  Use it to be on the
+	 * safe side.  (Yes, CMOS_WRITE does outb_p's. -  Paul G.)
 	 */
 	spin_lock(&rtc_lock);
 	CMOS_WRITE(0x00, 0x8f);
@@ -180,11 +187,12 @@ void machine_real_restart(unsigned int type)
 	 */
 	load_cr3(initial_page_table);
 
-	/* Write 0x1234 to absolute memory location 0x472.  The BIOS reads
-	   this on booting to tell it to "Bypass memory test (also warm
-	   boot)".  This seems like a fairly standard thing that gets set by
-	   REBOOT.COM programs, and the previous reset routine did this
-	   too. */
+	/*
+	 * Write 0x1234 to absolute memory location 0x472.  The BIOS reads
+	 * this on booting to tell it to "Bypass memory test (also warm
+	 * boot)".  This seems like a fairly standard thing that gets set by
+	 * REBOOT.COM programs, and the previous reset routine did this
+	 * too. */
 	*((unsigned short *)0x472) = reboot_mode;
 
 	/* Patch the GDT in the low memory trampoline */
@@ -233,7 +241,8 @@ static int __init set_kbd_reboot(const struct dmi_system_id *d)
 	return 0;
 }
 
-/* This is a single dmi_table handling all reboot quirks.  Note that
+/*
+ * This is a single dmi_table handling all reboot quirks.  Note that
  * REBOOT_BIOS is only available for 32bit
  */
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
@@ -262,7 +271,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745's SFF*/
+	{	/* Handle problems with rebooting on Dell Optiplex 745's SFF */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -270,7 +279,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745's DFF*/
+	{	/* Handle problems with rebooting on Dell Optiplex 745's DFF */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -279,7 +288,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
 		},
 	},
-	{       /* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
+	{	/* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 745",
 		.matches = {
@@ -288,7 +297,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
-	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+	{	/* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 330",
 		.matches = {
@@ -297,7 +306,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
-	{   /* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
+	{	/* Handle problems with rebooting on Dell Optiplex 360 with 0T656F */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 360",
 		.matches = {
@@ -306,7 +315,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
-	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G*/
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G */
 		.callback = set_bios_reboot,
 		.ident = "Dell OptiPlex 760",
 		.matches = {
@@ -379,7 +388,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
-	{       /* Handle problems with rebooting on ASUS P4S800 */
+	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
 		.ident = "ASUS P4S800",
 		.matches = {
@@ -389,7 +398,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	},
 #endif /* CONFIG_X86_32 */
 
-	{ /* Handle reboot issue on Acer Aspire one */
+	{	/* Handle reboot issue on Acer Aspire one */
 		.callback = set_kbd_reboot,
 		.ident = "Acer Aspire One A110",
 		.matches = {
@@ -466,12 +475,12 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 
 static int __init reboot_init(void)
 {
-	/* Only do the DMI check if reboot_type hasn't been overridden
+	/*
+	 * Only do the DMI check if reboot_type hasn't been overridden
 	 * on the command line
 	 */
-	if (reboot_default) {
+	if (reboot_default)
 		dmi_check_system(reboot_dmi_table);
-	}
 	return 0;
 }
 core_initcall(reboot_init);
@@ -492,14 +501,14 @@ static void vmxoff_nmi(int cpu, struct pt_regs *regs)
 	cpu_emergency_vmxoff();
 }
 
-/* Use NMIs as IPIs to tell all CPUs to disable virtualization
- */
+/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
 static void emergency_vmx_disable_all(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
-	/* We need to disable VMX on all CPUs before rebooting, otherwise
+	/*
+	 * We need to disable VMX on all CPUs before rebooting, otherwise
 	 * we risk hanging up the machine, because the CPU ignore INIT
 	 * signals when VMX is enabled.
 	 *
@@ -518,8 +527,7 @@ static void emergency_vmx_disable_all(void)
 	 * is still enabling VMX.
 	 */
 	if (cpu_has_vmx() && cpu_vmx_enabled()) {
-		/* Disable VMX on this CPU.
-		 */
+		/* Disable VMX on this CPU. */
 		cpu_vmxoff();
 
 		/* Halt and disable VMX on the other CPUs */
@@ -564,12 +572,12 @@ static void native_machine_emergency_restart(void)
 		/* Could also try the reset bit in the Hammer NB */
 		switch (reboot_type) {
 		case BOOT_KBD:
-			mach_reboot_fixups(); /* for board specific fixups */
+			mach_reboot_fixups(); /* For board specific fixups */
 
 			for (i = 0; i < 10; i++) {
 				kb_wait();
 				udelay(50);
-				outb(0xfe, 0x64); /* pulse reset low */
+				outb(0xfe, 0x64); /* Pulse reset low */
 				udelay(50);
 			}
 			if (attempt == 0 && orig_reboot_type == BOOT_ACPI) {
@@ -611,7 +619,7 @@ static void native_machine_emergency_restart(void)
 
 		case BOOT_CF9:
 			port_cf9_safe = true;
-			/* fall through */
+			/* Fall through */
 
 		case BOOT_CF9_COND:
 			if (port_cf9_safe) {
@@ -649,7 +657,8 @@ void native_machine_shutdown(void)
 	/* Make certain I only run on the appropriate processor */
 	set_cpus_allowed_ptr(current, cpumask_of(reboot_cpu_id));
 
-	/* O.K Now that I'm on the appropriate processor,
+	/*
+	 * O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
 	stop_other_cpus();
@@ -687,12 +696,11 @@ static void native_machine_restart(char *__unused)
 
 static void native_machine_halt(void)
 {
-	/* stop other cpus and apics */
+	/* Stop other cpus and apics */
 	machine_shutdown();
 
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 
-	/* stop this cpu */
 	stop_this_cpu(NULL);
 }
 
@@ -703,7 +711,7 @@ static void native_machine_power_off(void)
 			machine_shutdown();
 		pm_power_off();
 	}
-	/* a fallback in case there is no PM info available */
+	/* A fallback in case there is no PM info available */
 	tboot_shutdown(TB_SHUTDOWN_HALT);
 }
 
@@ -765,7 +773,8 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 
 	cpu = raw_smp_processor_id();
 
-	/* Don't do anything if this handler is invoked on crashing cpu.
+	/*
+	 * Don't do anything if this handler is invoked on crashing cpu.
 	 * Otherwise, system will completely hang. Crashing cpu can get
 	 * an NMI if system was initially booted with nmi_watchdog parameter.
 	 */
@@ -789,7 +798,8 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
-/* Halt all other CPUs, calling the specified function on each of them
+/*
+ * Halt all other CPUs, calling the specified function on each of them
  *
  * This function can be used to halt all other CPUs on crash
  * or emergency reboot time. The function passed as parameter
@@ -800,7 +810,7 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	unsigned long msecs;
 	local_irq_disable();
 
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	/* Make a note of crashing cpu. Will be used in NMI callback. */
 	crashing_cpu = safe_smp_processor_id();
 
 	shootdown_callback = callback;
@@ -809,8 +819,9 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* Would it be better to replace the trap vector here? */
 	if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
 				 NMI_FLAG_FIRST, "crash"))
-		return;		/* return what? */
-	/* Ensure the new callback function is set before sending
+		return;		/* Return what? */
+	/*
+	 * Ensure the new callback function is set before sending
 	 * out the NMI
 	 */
 	wmb();
