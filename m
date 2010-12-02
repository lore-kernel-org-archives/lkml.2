Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944Ab0LBQnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:43:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757776Ab0LBQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:42:40 -0500
From: Thomas Renninger <trenn@suse.de>
Cc: Thomas Renninger <trenn@suse.de>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 5/8] cpuidle: Introduce .abbr (abbrevation) for cpuidle states
Date: Thu,  2 Dec 2010 17:42:25 +0100
Message-Id: <1291308148-28628-6-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1291308148-28628-5-git-send-email-trenn@suse.de>
References: <1291308148-28628-1-git-send-email-trenn@suse.de>
 <1291308148-28628-2-git-send-email-trenn@suse.de>
 <1291308148-28628-3-git-send-email-trenn@suse.de>
 <1291308148-28628-4-git-send-email-trenn@suse.de>
 <1291308148-28628-5-git-send-email-trenn@suse.de>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

and fill name, description and newly introduced abbrivation
consistenly (always use snprintf) in all cpuidle drivers.

This is mainly for perf timechart. It draws vector graphics
pictures of sleep/idle state usage catching perf cpu_idle events.
The string used for the idle state must not exceed 3 chars or
you can't see much in these pictures.
The name could get used in the title, the introduced abbrivations
inside of the picture and the text must therefore be rather short.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: lenb@kernel.org
CC: linux-acpi@vger.kernel.org
CC: linux-pm@lists.linux-foundation.org
CC: Arjan van de Ven <arjan@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
CC: linux-omap@vger.kernel.org
---
 arch/arm/mach-at91/cpuidle.c          |   12 ++++++++----
 arch/arm/mach-davinci/cpuidle.c       |   13 +++++++++----
 arch/arm/mach-kirkwood/cpuidle.c      |   12 ++++++++----
 arch/arm/mach-omap2/cpuidle34xx.c     |    3 ++-
 arch/sh/kernel/cpu/shmobile/cpuidle.c |   19 +++++++++++--------
 drivers/acpi/processor_idle.c         |    3 +++
 drivers/cpuidle/cpuidle.c             |    1 +
 drivers/cpuidle/sysfs.c               |    3 +++
 drivers/idle/intel_idle.c             |   11 +++++++++++
 include/linux/cpuidle.h               |    2 ++
 10 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mach-at91/cpuidle.c b/arch/arm/mach-at91/cpuidle.c
index 1cfeac1..6cdeb42 100644
--- a/arch/arm/mach-at91/cpuidle.c
+++ b/arch/arm/mach-at91/cpuidle.c
@@ -73,16 +73,20 @@ static int at91_init_cpuidle(void)
 	device->states[0].exit_latency = 1;
 	device->states[0].target_residency = 10000;
 	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	snprintf(device->states[0].name, CPUIDLE_NAME_LEN, "WFI");
+	snprintf(device->states[0].desc, CPUIDLE_DESC_LEN,
+		 "Wait for interrupt");
+	snprintf(device->states[0].abbr, CPUIDLE_ABBR_LEN, "W");
 
 	/* Wait for interrupt and RAM self refresh state */
 	device->states[1].enter = at91_enter_idle;
 	device->states[1].exit_latency = 10;
 	device->states[1].target_residency = 10000;
 	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "RAM_SR");
-	strcpy(device->states[1].desc, "WFI and RAM Self Refresh");
+	snprintf(device->states[1].name, CPUIDLE_NAME_LEN, "RAM SR");
+	snprintf(device->states[1].desc, CPUIDLE_DESC_LEN,
+		 "WFI and RAM Self Refresh");
+	snprintf(device->states[1].abbr, CPUIDLE_ABBR_LEN, "WSR");
 
 	if (cpuidle_register_device(device)) {
 		printk(KERN_ERR "at91_init_cpuidle: Failed registering\n");
diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index bd59f31..42ad2d6 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -127,16 +127,21 @@ static int __init davinci_cpuidle_probe(struct platform_device *pdev)
 	device->states[0].exit_latency = 1;
 	device->states[0].target_residency = 10000;
 	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	snprintf(device->states[0].name, CPUIDLE_NAME_LEN, "WFI");
+	snprintf(device->states[0].desc, CPUIDLE_DESC_LEN,
+		 "Wait for interrupt");
+	snprintf(device->states[0].abbr, CPUIDLE_ABBR_LEN, "W");
 
 	/* Wait for interrupt and DDR self refresh state */
 	device->states[1].enter = davinci_enter_idle;
 	device->states[1].exit_latency = 10;
 	device->states[1].target_residency = 10000;
 	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "DDR SR");
-	strcpy(device->states[1].desc, "WFI and DDR Self Refresh");
+	snprintf(device->states[1].name, CPUIDLE_NAME_LEN, "RAM SR");
+	snprintf(device->states[1].desc, CPUIDLE_DESC_LEN,
+		 "WFI and RAM Self Refresh");
+	snprintf(device->states[1].abbr, CPUIDLE_ABBR_LEN, "WSR");
+
 	if (pdata->ddr2_pdown)
 		davinci_states[1].flags |= DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN;
 	cpuidle_set_statedata(&device->states[1], &davinci_states[1]);
diff --git a/arch/arm/mach-kirkwood/cpuidle.c b/arch/arm/mach-kirkwood/cpuidle.c
index f68d33f..48eaabb 100644
--- a/arch/arm/mach-kirkwood/cpuidle.c
+++ b/arch/arm/mach-kirkwood/cpuidle.c
@@ -75,16 +75,20 @@ static int kirkwood_init_cpuidle(void)
 	device->states[0].exit_latency = 1;
 	device->states[0].target_residency = 10000;
 	device->states[0].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[0].name, "WFI");
-	strcpy(device->states[0].desc, "Wait for interrupt");
+	snprintf(device->states[0].name, CPUIDLE_NAME_LEN, "WFI");
+	snprintf(device->states[0].desc, CPUIDLE_DESC_LEN,
+		 "Wait for interrupt");
+	snprintf(device->states[0].abbr, CPUIDLE_ABBR_LEN, "W");
 
 	/* Wait for interrupt and DDR self refresh state */
 	device->states[1].enter = kirkwood_enter_idle;
 	device->states[1].exit_latency = 10;
 	device->states[1].target_residency = 10000;
 	device->states[1].flags = CPUIDLE_FLAG_TIME_VALID;
-	strcpy(device->states[1].name, "DDR SR");
-	strcpy(device->states[1].desc, "WFI and DDR Self Refresh");
+	snprintf(device->states[1].name, CPUIDLE_NAME_LEN, "RAM SR");
+	snprintf(device->states[1].desc, CPUIDLE_DESC_LEN,
+		 "WFI and RAM Self Refresh");
+	snprintf(device->states[1].abbr, CPUIDLE_ABBR_LEN, "WSR");
 
 	if (cpuidle_register_device(device)) {
 		printk(KERN_ERR "kirkwood_init_cpuidle: Failed registering\n");
diff --git a/arch/arm/mach-omap2/cpuidle34xx.c b/arch/arm/mach-omap2/cpuidle34xx.c
index 0d50b45..a59ac39 100644
--- a/arch/arm/mach-omap2/cpuidle34xx.c
+++ b/arch/arm/mach-omap2/cpuidle34xx.c
@@ -496,7 +496,8 @@ int __init omap3_idle_init(void)
 			omap3_enter_idle_bm : omap3_enter_idle;
 		if (cx->type == OMAP3_STATE_C1)
 			dev->safe_state = state;
-		sprintf(state->name, "C%d", count+1);
+		snprintf(state->name, CPUIDLE_NAME_LEN, "C%d", count+1);
+		snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C%d", count+1);
 		count++;
 	}
 
diff --git a/arch/sh/kernel/cpu/shmobile/cpuidle.c b/arch/sh/kernel/cpu/shmobile/cpuidle.c
index 83972aa..9ad151d 100644
--- a/arch/sh/kernel/cpu/shmobile/cpuidle.c
+++ b/arch/sh/kernel/cpu/shmobile/cpuidle.c
@@ -75,8 +75,9 @@ void sh_mobile_setup_cpuidle(void)
 	i = CPUIDLE_DRIVER_STATE_START;
 
 	state = &dev->states[i++];
-	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
-	strncpy(state->desc, "SuperH Sleep Mode", CPUIDLE_DESC_LEN);
+	snprintf(state->name, CPUIDLE_NAME_LEN, "SuperH");
+	snprintf(state->desc, CPUIDLE_DESC_LEN, "SuperH Sleep Mode");
+	snprintf(state->abbr, CPUIDLE_ABBR_LEN, "SH");
 	state->exit_latency = 1;
 	state->target_residency = 1 * 2;
 	state->power_usage = 3;
@@ -89,9 +90,10 @@ void sh_mobile_setup_cpuidle(void)
 
 	if (sh_mobile_sleep_supported & SUSP_SH_SF) {
 		state = &dev->states[i++];
-		snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
-		strncpy(state->desc, "SuperH Sleep Mode [SF]",
-			CPUIDLE_DESC_LEN);
+		snprintf(state->name, CPUIDLE_NAME_LEN, "SuperH [SF]");
+		snprintf(state->desc, CPUIDLE_DESC_LEN,
+			 "SuperH Sleep Mode [SF]");
+		snprintf(state->abbr, CPUIDLE_ABBR_LEN, "SHF");
 		state->exit_latency = 100;
 		state->target_residency = 1 * 2;
 		state->power_usage = 1;
@@ -102,9 +104,10 @@ void sh_mobile_setup_cpuidle(void)
 
 	if (sh_mobile_sleep_supported & SUSP_SH_STANDBY) {
 		state = &dev->states[i++];
-		snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
-		strncpy(state->desc, "SuperH Mobile Standby Mode [SF]",
-			CPUIDLE_DESC_LEN);
+		snprintf(state->name, CPUIDLE_NAME_LEN, "SuperH Standby [SF]");
+		snprintf(state->desc, CPUIDLE_DESC_LEN,
+			 "SuperH Mobile Standby Mode [SF]");
+		snprintf(state->abbr, CPUIDLE_ABBR_LEN, "SHS");
 		state->exit_latency = 2300;
 		state->target_residency = 1 * 2;
 		state->power_usage = 1;
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index dda3412..e74f72c 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1023,6 +1023,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 		switch (cx->type) {
 			case ACPI_STATE_C1:
 			snprintf(state->name, CPUIDLE_NAME_LEN, "C1");
+			snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C1");
 			state->flags |= CPUIDLE_FLAG_SHALLOW;
 			if (cx->entry_method == ACPI_CSTATE_FFH)
 				state->flags |= CPUIDLE_FLAG_TIME_VALID;
@@ -1033,6 +1034,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 
 			case ACPI_STATE_C2:
 			snprintf(state->name, CPUIDLE_NAME_LEN, "C2");
+			snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C2");
 			state->flags |= CPUIDLE_FLAG_BALANCED;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->enter = acpi_idle_enter_simple;
@@ -1041,6 +1043,7 @@ static int acpi_processor_setup_cpuidle(struct acpi_processor *pr)
 
 			case ACPI_STATE_C3:
 			snprintf(state->name, CPUIDLE_NAME_LEN, "C3");
+			snprintf(state->abbr, CPUIDLE_ABBR_LEN, "C3");
 			state->flags |= CPUIDLE_FLAG_DEEP;
 			state->flags |= CPUIDLE_FLAG_TIME_VALID;
 			state->flags |= CPUIDLE_FLAG_CHECK_BM;
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 4649495..b2d2b69 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -268,6 +268,7 @@ static void poll_idle_init(struct cpuidle_device *dev)
 
 	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");
 	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
+	snprintf(state->abbr, CPUIDLE_ABBR_LEN, "P");
 	state->exit_latency = 0;
 	state->target_residency = 0;
 	state->power_usage = -1;
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 0310ffa..ca7a62c 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -249,9 +249,11 @@ define_show_state_ull_function(usage)
 define_show_state_ull_function(time)
 define_show_state_str_function(name)
 define_show_state_str_function(desc)
+define_show_state_str_function(abbr)
 
 define_one_state_ro(name, show_state_name);
 define_one_state_ro(desc, show_state_desc);
+define_one_state_ro(abbr, show_state_abbr);
 define_one_state_ro(latency, show_state_exit_latency);
 define_one_state_ro(power, show_state_power_usage);
 define_one_state_ro(usage, show_state_usage);
@@ -260,6 +262,7 @@ define_one_state_ro(time, show_state_time);
 static struct attribute *cpuidle_state_default_attrs[] = {
 	&attr_name.attr,
 	&attr_desc.attr,
+	&attr_abbr.attr,
 	&attr_latency.attr,
 	&attr_power.attr,
 	&attr_usage.attr,
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f0798ff..b2954a0 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -91,6 +91,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "NHM-C1",
 		.desc = "MWAIT 0x00",
+		.abbr = "C1",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 3,
@@ -99,6 +100,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "NHM-C3",
 		.desc = "MWAIT 0x10",
+		.abbr = "C3",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 20,
@@ -107,6 +109,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C3 */
 		.name = "NHM-C6",
 		.desc = "MWAIT 0x20",
+		.abbr = "C6",
 		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 200,
@@ -119,6 +122,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "SNB-C1",
 		.desc = "MWAIT 0x00",
+		.abbr = "C1",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
@@ -127,6 +131,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "SNB-C3",
 		.desc = "MWAIT 0x10",
+		.abbr = "C3",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 80,
@@ -135,6 +140,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C3 */
 		.name = "SNB-C6",
 		.desc = "MWAIT 0x20",
+		.abbr = "C6",
 		.driver_data = (void *) 0x20,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 104,
@@ -143,6 +149,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C4 */
 		.name = "SNB-C7",
 		.desc = "MWAIT 0x30",
+		.abbr = "C7",
 		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 109,
@@ -155,6 +162,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C1 */
 		.name = "ATM-C1",
 		.desc = "MWAIT 0x00",
+		.abbr = "C1",
 		.driver_data = (void *) 0x00,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 1,
@@ -163,6 +171,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C2 */
 		.name = "ATM-C2",
 		.desc = "MWAIT 0x10",
+		.abbr = "C2",
 		.driver_data = (void *) 0x10,
 		.flags = CPUIDLE_FLAG_TIME_VALID,
 		.exit_latency = 20,
@@ -172,6 +181,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C4 */
 		.name = "ATM-C4",
 		.desc = "MWAIT 0x30",
+		.abbr = "C4",
 		.driver_data = (void *) 0x30,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 100,
@@ -181,6 +191,7 @@ static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C6 */
 		.name = "ATM-C6",
 		.desc = "MWAIT 0x52",
+		.abbr = "C6",
 		.driver_data = (void *) 0x52,
 		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 140,
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 1be416b..4763ef3 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -20,6 +20,7 @@
 #define CPUIDLE_STATE_MAX	8
 #define CPUIDLE_NAME_LEN	16
 #define CPUIDLE_DESC_LEN	32
+#define CPUIDLE_ABBR_LEN	3
 
 struct cpuidle_device;
 
@@ -31,6 +32,7 @@ struct cpuidle_device;
 struct cpuidle_state {
 	char		name[CPUIDLE_NAME_LEN];
 	char		desc[CPUIDLE_DESC_LEN];
+	char		abbr[CPUIDLE_ABBR_LEN];
 	void		*driver_data;
 
 	unsigned int	flags;
-- 
1.6.0.2

