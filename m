Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab2DCIMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:12:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2DCILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:11:43 -0400
Date: Tue, 3 Apr 2012 01:11:11 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-7b8e6da46b921d30ac1553cac56d8fb74f0b431d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com,
        bonbons@linux-vserver.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        rostedt@goodmis.org, ming.m.lin@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bonbons@linux-vserver.org,
        eranian@google.com, linux-kernel@vger.kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, rostedt@goodmis.org,
        ming.m.lin@intel.com, tglx@linutronix.de
In-Reply-To: <1332859842.16159.227.camel@twins>
References: <1332859842.16159.227.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/p4: Add format attributes
Git-Commit-ID: 7b8e6da46b921d30ac1553cac56d8fb74f0b431d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 03 Apr 2012 01:11:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b8e6da46b921d30ac1553cac56d8fb74f0b431d
Gitweb:     http://git.kernel.org/tip/7b8e6da46b921d30ac1553cac56d8fb74f0b431d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 27 Mar 2012 16:50:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 3 Apr 2012 08:33:38 +0200

perf/x86/p4: Add format attributes

Steven reported his P4 not booting properly, the missing format
attributes cause a NULL ptr deref. Cure this by adding the
missing format specification.

I took the format description out of the comment near
p4_config_pack*() and hope that comment is still relatively
accurate.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Tested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1332859842.16159.227.camel@twins
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index ef484d9..a2dfacf 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1271,6 +1271,17 @@ done:
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
@@ -1305,6 +1316,8 @@ static __initconst const struct x86_pmu p4_pmu = {
 	 * the former idea is taken from OProfile code
 	 */
 	.perfctr_second_write	= 1,
+
+	.format_attrs		= intel_p4_formats_attr,
 };
 
 __init int p4_pmu_init(void)
