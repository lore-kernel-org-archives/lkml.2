Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab0HRIAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:00:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:4124 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab0HRIAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:00:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,226,1280732400"; 
   d="scan'208";a="829229189"
Subject: Re: [RFC PATCH 1/3] perf: export perf helper functions
From: Zhang Rui <rui.zhang@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "\"robert .richter\"@amd.com" <"robert .richter"@amd.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <1282118367.5181.116.camel@rui>
References: <1282118367.5181.116.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 16:03:41 +0800
Message-ID: <1282118621.5181.121.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend with the correct email address. :p

Export some perf helper functions.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 include/linux/perf_event.h |    2 ++
 kernel/perf_event.c        |   12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4572,7 +4572,7 @@ static enum hrtimer_restart perf_swevent
 	return ret;
 }
 
-static void perf_swevent_start_hrtimer(struct perf_event *event)
+void perf_swevent_start_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -4595,7 +4595,9 @@ static void perf_swevent_start_hrtimer(s
 	}
 }
 
-static void perf_swevent_cancel_hrtimer(struct perf_event *event)
+EXPORT_SYMBOL(perf_swevent_start_hrtimer);
+
+void perf_swevent_cancel_hrtimer(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
@@ -4607,6 +4609,8 @@ static void perf_swevent_cancel_hrtimer(
 	}
 }
 
+EXPORT_SYMBOL(perf_swevent_cancel_hrtimer);
+
 /*
  * Software event: cpu wall time clock
  */
@@ -4815,6 +4819,8 @@ unlock:
 	return ret;
 }
 
+EXPORT_SYMBOL(perf_pmu_register);
+
 void perf_pmu_unregister(struct pmu *pmu)
 {
 	mutex_lock(&pmus_lock);
@@ -4825,6 +4831,8 @@ void perf_pmu_unregister(struct pmu *pmu
 	synchronize_srcu(&pmus_srcu);
 }
 
+EXPORT_SYMBOL(perf_pmu_unregister);
+
 struct pmu *perf_init_event(struct perf_event *event)
 {
 	struct pmu *pmu = NULL;
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -888,6 +888,8 @@ extern int perf_max_events;
 
 extern int perf_pmu_register(struct pmu *pmu);
 extern void perf_pmu_unregister(struct pmu *pmu);
+extern void perf_swevent_start_hrtimer(struct perf_event *event);
+extern void perf_swevent_cancel_hrtimer(struct perf_event *event);
 
 extern void perf_event_task_sched_in(struct task_struct *task);
 extern void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next);


