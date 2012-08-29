Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab2H2NB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 09:01:27 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60107 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2H2NB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 09:01:26 -0400
Date: Wed, 29 Aug 2012 15:01:22 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, andi@firstfloor.org, zheng.z.yan@intel.com,
        mingo@elte.hu
Subject: [PATCH] perf/x86: export Sandy Bridge uncore clockticks event in
 sysfs
Message-ID: <20120829130122.GA32336@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch exports the clockticks event and its encoding to user level.
The clockticks event was exported for Nehalem/Westmere but not for Sandy
Bridge (client). Given that it uses a special encoding, it needs to be
exported to user tools, so users can do:

  # perf stat -a -C 0 -e uncore_cbox_0/clockticks/ sleep 1

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 0a55710..38e4894 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -661,6 +661,11 @@ static void snb_uncore_msr_init_box(struct intel_uncore_box *box)
 	}
 }
 
+static struct uncore_event_desc snb_uncore_events[] = {
+	INTEL_UNCORE_EVENT_DESC(clockticks, "event=0xff,umask=0x00"),
+	{ /* end: all zeroes */ },
+};
+
 static struct attribute *snb_uncore_formats_attr[] = {
 	&format_attr_event.attr,
 	&format_attr_umask.attr,
@@ -704,6 +709,7 @@ static struct intel_uncore_type snb_uncore_cbox = {
 	.constraints	= snb_uncore_cbox_constraints,
 	.ops		= &snb_uncore_msr_ops,
 	.format_group	= &snb_uncore_format_group,
+	.event_descs	= snb_uncore_events,
 };
 
 static struct intel_uncore_type *snb_msr_uncores[] = {
