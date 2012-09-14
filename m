Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab2INGRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:17:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab2INGRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:17:09 -0400
Date: Thu, 13 Sep 2012 23:16:55 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-35534b201c9f115c68962c095b5a9aad204d025f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, zheng.z.yan@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <20120829130122.GA32336@quad>
References: <20120829130122.GA32336@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Export Sandy Bridge uncore clockticks event in sysfs
Git-Commit-ID: 35534b201c9f115c68962c095b5a9aad204d025f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:17:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35534b201c9f115c68962c095b5a9aad204d025f
Gitweb:     http://git.kernel.org/tip/35534b201c9f115c68962c095b5a9aad204d025f
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 29 Aug 2012 15:01:22 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:59:46 +0200

perf/x86: Export Sandy Bridge uncore clockticks event in sysfs

This patch exports the clockticks event and its encoding to user level.
The clockticks event was exported for Nehalem/Westmere but not for Sandy
Bridge (client). Given that it uses a special encoding, it needs to be
exported to user tools, so users can do:

  # perf stat -a -C 0 -e uncore_cbox_0/clockticks/ sleep 1

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120829130122.GA32336@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

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
