Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab0IENIk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 09:08:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:38349 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0IENIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 09:08:38 -0400
Date: Sun, 5 Sep 2010 13:06:45 GMT
From: tip-bot for Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        lm-sensors@lm-sensors.org, jin.dongming@np.css.fujitsu.com,
        seto.hidetoshi@jp.fujitsu.com, fenghua.yu@intel.com,
        khali@linux-fr.org, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu, len.brown@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jin.dongming@np.css.fujitsu.com, lm-sensors@lm-sensors.org,
        seto.hidetoshi@jp.fujitsu.com, fenghua.yu@intel.com,
        khali@linux-fr.org, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu, len.brown@intel.com
In-Reply-To: <4C7C492D.5020704@np.css.fujitsu.com>
References: <4C7C492D.5020704@np.css.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] therm_throt.c: Trival printk message fix for a unsuitable abbreviation of 'thermal'
Message-ID: <tip-6981fe03b2055685fb6da40f54518bc6baf2b751@git.kernel.org>
Git-Commit-ID: 6981fe03b2055685fb6da40f54518bc6baf2b751
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 05 Sep 2010 13:06:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6981fe03b2055685fb6da40f54518bc6baf2b751
Gitweb:     http://git.kernel.org/tip/6981fe03b2055685fb6da40f54518bc6baf2b751
Author:     Jin Dongming <jin.dongming@np.css.fujitsu.com>
AuthorDate: Tue, 31 Aug 2010 09:13:33 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 5 Sep 2010 14:39:15 +0200

therm_throt.c: Trival printk message fix for a unsuitable abbreviation of 'thermal'

In unexpected_thermal_interrupt(), "LVT TMR interrupt" is used
in error message.

I don't think TMR is a suitable abbreviation for thermal.
  1.TMR has been used in IA32 Architectures Software Developer's
    Manual, and is the abbreviation for Trigger Mode Register.
  2.There is not an standard abbreviation "TMR" defined for thermal
    in IA32 Architectures Software Developer's Manual.
  3.Though we could understand it as Thermal Monitor Register, it is
    easy to be misunderstood as a *TIMER* interrupt also.

I think this patch will fix it.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Brown
Cc: Len <len.brown@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: lm-sensors@lm-sensors.org <lm-sensors@lm-sensors.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
LKML-Reference: <4C7C492D.5020704@np.css.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..1d0f743 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -348,7 +348,7 @@ static void intel_thermal_interrupt(void)
 
 static void unexpected_thermal_interrupt(void)
 {
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
 	add_taint(TAINT_MACHINE_CHECK);
 }
