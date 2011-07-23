Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GWMUD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 08:20:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35498 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab1GWMT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 08:19:59 -0400
Date: Sat, 23 Jul 2011 14:19:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] x86/tsc change for v3.1
Message-ID: <20110723121912.GA1435@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-tsc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-tsc-for-linus

 Thanks,

	Ingo

------------------>
Tero Roponen (1):
      x86: tsc: Remove unneeded DMI-based blacklisting


 arch/x86/kernel/tsc.c |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

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
