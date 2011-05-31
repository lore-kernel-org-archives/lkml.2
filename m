Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab1EaHYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:24:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48433 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab1EaHYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Lo2gFdwTevM0S3PG+rYHIwQHTuASNSMrFXKq6qYVzK9o1dg68KLGgLm5BxMbnQ8rwL
         bkuq/kOi2IAqR4CzOQiniADkTduJKyuhph1xIkJlRpA0lECkKh6qRZ2JSX7yCDsm6wF8
         I0T+EUww9nNvfHOxD5nl3I9jdKPjPgsl0Xl+o=
Date: Tue, 31 May 2011 10:24:39 +0300 (EEST)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@terrop
To: linux-kernel@vger.kernel.org
cc: johnstul@us.ibm.com, tglx@linutronix.de, mingo@elte.hu
Subject: x86: tsc: Remove unneeded DMI-based blacklisting
Message-ID: <alpine.LFD.2.02.1105311020590.7332@terrop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blacklist was added in response to my bug report
(http://lkml.org/lkml/2006/1/19/362) and has never
contained more than the one entry describing my old
now dead ThinkPad 380XD laptop. As found out later
(http://lkml.org/lkml/2007/11/29/50), this special
treatment has been unnecessary for a long time, so
it can be removed.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6cc6922..5c45c62 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -5,7 +5,6 @@
 #include <linux/timer.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/cpufreq.h>
-#include <linux/dmi.h>
 #include <linux/delay.h>
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
@@ -800,27 +799,6 @@ void mark_tsc_unstable(char *reason)
 
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
-static int __init dmi_mark_tsc_unstable(const struct dmi_system_id *d)
-{
-	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
-			d->ident);
-	tsc_unstable = 1;
-	return 0;
-}
-
-/* List of systems that have known TSC problems */
-static struct dmi_system_id __initdata bad_tsc_dmi_table[] = {
-	{
-		.callback = dmi_mark_tsc_unstable,
-		.ident = "IBM Thinkpad 380XD",
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "IBM"),
-			DMI_MATCH(DMI_BOARD_NAME, "2635FA0"),
-		},
-	},
-	{}
-};
-
 static void __init check_system_tsc_reliable(void)
 {
 #ifdef CONFIG_MGEODE_LX
@@ -1010,8 +988,6 @@ void __init tsc_init(void)
 	lpj_fine = lpj;
 
 	use_tsc_delay();
-	/* Check and install the TSC clocksource */
-	dmi_check_system(bad_tsc_dmi_table);
 
 	if (unsynchronized_tsc())
 		mark_tsc_unstable("TSCs unsynchronized");
