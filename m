Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0HaAND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:13:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35356 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab0HaANB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:13:01 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C7C492D.5020704@np.css.fujitsu.com>
Date: Tue, 31 Aug 2010 09:13:33 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>
CC: "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [Patch-next -v2]therm_throt.c: Trival fix for a unsuitable  abbreviation
 of thermal.
References: <4C7B6358.3040703@np.css.fujitsu.com> <20100830095753.6724bc89@hyperion.delvare>
In-Reply-To: <20100830095753.6724bc89@hyperion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d9368ee..ba52598 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -349,7 +349,7 @@ static void intel_thermal_interrupt(void)
 
 static void unexpected_thermal_interrupt(void)
 {
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+	printk(KERN_ERR "CPU%d: Unexpected LVT thermal interrupt!\n",
 			smp_processor_id());
 	add_taint(TAINT_MACHINE_CHECK);
 }
-- 
1.7.1.1



