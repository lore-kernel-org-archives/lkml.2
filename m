Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0IQWRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:17:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:46439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129Ab0IQWRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:17:18 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Sat, 18 Sep 2010 00:17:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, discuss@lesswatts.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009171508.46471.trenn@suse.de> <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
In-Reply-To: <AANLkTi=W_Lo2m=hkA2F48oUziqGzt4Tr8y6KhfgqRnbz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009180017.03821.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DO NOT APPLY THIS ONE!!!
	
The others should go into a mainline tree if Jean is ok with them.

This one does not work, due to some include dependencies or whatever
else I can't see right now.

The idea: Provide old trace power interfaces via .config option to not break
existing perf/powertop/.. binaries.
Not sure whether it's worth looking at it further. It shouldn't be needed...

       Thomas

---
 include/trace/events/power.h |   11 +++++++++++
 kernel/trace/Kconfig         |    4 ++++
 2 files changed, 15 insertions(+)

Index: linux-2.6.35-master/kernel/trace/Kconfig
===================================================================
--- linux-2.6.35-master.orig/kernel/trace/Kconfig
+++ linux-2.6.35-master/kernel/trace/Kconfig
@@ -64,6 +64,10 @@ config EVENT_TRACING
 	select CONTEXT_SWITCH_TRACER
 	bool
 
+config DEPRECATED_POWER_EVENT_TRACING
+       bool
+       default n
+
 config CONTEXT_SWITCH_TRACER
 	bool
 
Index: linux-2.6.35-master/include/trace/events/power.h
===================================================================
--- linux-2.6.35-master.orig/include/trace/events/power.h
+++ linux-2.6.35-master/include/trace/events/power.h
@@ -50,6 +50,7 @@ DEFINE_EVENT(power, power_switch_state,
 	TP_ARGS(type, state, cpu_id)
 );
 
+#ifdef CONFIG_DEPRECATED_POWER_EVENT_TRACING
 DEFINE_EVENT(power, power_start,
 
 	TP_PROTO(unsigned int type, unsigned int state, unsigned int cpu_id),
@@ -81,6 +82,16 @@ TRACE_EVENT(power_end,
 	TP_printk("cpu_id=%lu", (unsigned long)__entry->cpu_id)
 
 );
+#else
+inline void trace_power_end(unsigned int cpu_id)
+{}
+inline void trace_power_start(unsigned int type, unsigned int state,
+			      unsigned int cpu_id)
+{}
+inline void trace_power_frequency(unsigned int type, unsigned int state,
+				  unsigned int cpu_id)
+{}
+#endif
 
 /*
  * The clock events are used for clock enable/disable and for

