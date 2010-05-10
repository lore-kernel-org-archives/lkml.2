Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0EJJaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:30:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:45812 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0EJJaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:30:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,361,1270450800"; 
   d="scan'208";a="275210201"
Subject: [RFC][PATCH 9/9] perf top: set perf_event_attr->pmu_id
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 10 May 2010 17:29:20 +0800
Message-Id: <1273483760.15998.63.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a temporary patch to show the setting of
perf_event_attr->pmu_id. 

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 tools/perf/builtin-top.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ed9b5b6..f775393 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1213,6 +1213,11 @@ static void start_counter(int i, int counter)
 
 	attr = attrs + counter;
 
+	/*
+	 * TBD: in the future, may read /sys/devices/system/cpu/pmus/<pmu_id> 
+	 * to get the pmu id
+	 */
+	attr.pmu_id = 0;
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	if (freq) {


