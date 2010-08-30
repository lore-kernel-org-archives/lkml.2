Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab0H3MOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:14:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39384 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546Ab0H3MNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:51 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 4/5] sh: Add support for sampling counters
Date: Mon, 30 Aug 2010 13:13:46 +0100
Message-Id: <b8f8fabb61505b10360b358016e97283ba8a621f.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SH performance counters cannot generate any form of interrupt and so
require hrtimer assistance for sampling counter values. Event groups
periodically sample counters when a hrtimer fires which allows the use
of sampling counters on SH.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 arch/sh/kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 7a3dc35..1f77de6 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -114,7 +114,8 @@ static int __hw_perf_event_init(struct perf_event *event)
 	 * no interrupts, and are therefore unable to do sampling without
 	 * further work and timer assistance.
 	 */
-	if (hwc->sample_period)
+	if (!(attr->read_format & PERF_FORMAT_GROUP) &&
+	    hwc->sample_period && event->group_leader == event)
 		return -EINVAL;
 
 	/*
-- 
1.7.1

