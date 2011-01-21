Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1AUEMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 23:12:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:44890 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab1AUEMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 23:12:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,355,1291622400"; 
   d="scan'208";a="699043453"
Date: Thu, 20 Jan 2011 20:12:40 -0800
From: Fenghua Yu <fenghua.yu@intel.com>
To: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86,mcheck,therm_throt.c: Export symbol platform_thermal_notify to allow coretemp to handler intr
Message-ID: <20110121041239.GB26954@linux-os.sc.intel.com>
References: <D6D887BA8C9DFF48B5233887EF046541094482ED6A@bgsmsx502.gar.corp.intel.com> <20110120221704.GA26954@linux-os.sc.intel.com> <20110121022611.GC9496@ericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121022611.GC9496@ericsson.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In therm_throt.c, commit 9e76a97efd31a08cb19d0ba12013b8fb4ad3e474 patch
doesn't export the symbol platform_thermal_notify.

Other drivers (e.g. drivers/hwmon/coretemp.c) can not find the symbol
platform_thermal_notify when defining threshould interrupt handler.

Please apply this patch to allow threshold interrupt handler in coretemp.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---

 arch/x86/kernel/cpu/mcheck/therm_throt.c |    1 +
 1 files changed, 1 insertion(+)


diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index e12246f..6f8c5e9 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -59,6 +59,7 @@ struct thermal_state {
 
 /* Callback to handle core threshold interrupts */
 int (*platform_thermal_notify)(__u64 msr_val);
+EXPORT_SYMBOL(platform_thermal_notify);
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
