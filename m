Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab2C0Ou7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:50:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:51592 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2C0Ou4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:50:56 -0400
Message-ID: <1332859842.16159.227.camel@twins>
Subject: [PATCH] perf, p4: Add format attributes
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Lin Ming <ming.m.lin@intel.com>, rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 27 Mar 2012 16:50:42 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf, p4: Add format attributes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Mar 27 16:19:25 CEST 2012

Steven reported his P4 not booting properly, the missing format
attributes cause a NULL ptr deref. Cure this by adding the missing
format specification.

I took the format description out of the comment near 
p4_config_pack*() and hope that comment is still relatively 
accurate.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1271,6 +1271,17 @@ static int p4_pmu_schedule_events(struct
 	return num ? -EINVAL : 0;
 }
 
+PMU_FORMAT_ATTR(cccr, "config:0-31" );
+PMU_FORMAT_ATTR(escr, "config:32-62");
+PMU_FORMAT_ATTR(ht,   "config:63"   );
+
+static struct attribute *intel_p4_formats_attr[] = {
+	&format_attr_cccr.attr,
+	&format_attr_escr.attr,
+	&format_attr_ht.attr,
+	NULL,
+};
+
 static __initconst const struct x86_pmu p4_pmu = {
 	.name			= "Netburst P4/Xeon",
 	.handle_irq		= p4_pmu_handle_irq,
@@ -1305,6 +1316,8 @@ static __initconst const struct x86_pmu
 	 * the former idea is taken from OProfile code
 	 */
 	.perfctr_second_write	= 1,
+
+	.format_attrs		= intel_p4_formats_attr,
 };
 
 __init int p4_pmu_init(void)

