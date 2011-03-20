Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab1CTSyp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 14:54:45 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:62543 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1CTSyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 14:54:43 -0400
X-IronPort-AV: E=Sophos;i="4.63,215,1299456000"; 
   d="scan'208";a="349369468"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 0/5] perf events: Add time-of-day to perf samples
Date: Sun, 20 Mar 2011 12:54:32 -0600
Message-Id: <1300647277-8431-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than collecting data to correlate the perf_clock timestamps to
time-of-day this approach adds the realtime clock value directly to the
perf sample.

David Ahern (5):
  perf events: add support for realtime clock attribute
  perf events: userspace plumbing for realtime sample attribute
  perf record: add time-of-day option
  perf script: add support for time-of-day strings in output
  perf python: add REALTIME to constants

 include/linux/perf_event.h               |    4 +-
 kernel/perf_event.c                      |   12 ++++
 tools/perf/Documentation/perf-record.txt |    4 ++
 tools/perf/Documentation/perf-script.txt |    8 +++-
 tools/perf/builtin-record.c              |    5 ++
 tools/perf/builtin-script.c              |   84 +++++++++++++++++++++++++++++-
 tools/perf/util/event.c                  |    1 +
 tools/perf/util/event.h                  |    1 +
 tools/perf/util/evsel.c                  |   10 ++++
 tools/perf/util/python.c                 |    1 +
 tools/perf/util/session.c                |    6 ++
 11 files changed, 133 insertions(+), 3 deletions(-)

-- 
1.7.4

