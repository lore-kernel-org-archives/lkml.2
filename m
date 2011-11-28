Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1K1JFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:05:16 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33766 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab1K1JFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:05:12 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: [PATCH 0/7] Profiling sleep times (v3)
Date: Mon, 28 Nov 2011 12:03:28 +0300
Message-Id: <1322471015-107825-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you want to know where your code waits locks for a long time?
Yes! It's for you. This feature helps you to find bottlenecks.

It's not artificial task. Once one of my colleague was investigating a
scalability problem. He pressed sysrq-t some times and tried to merge
call-chains by hand. But perf can do that.

Problem:
The problem is that events sched_stat_* contain call-chains of
non-target tasks.
About month ago I sent series of patches:

[PATCH 0/3] trace: add ability to collect call chains of non current task.

Peter and Frederic explained me, that this solve isn't good and will be
better to make it in userspace.

Now it's in userspace. This series expands "perf inject" to be able to
merge sched_switch events and sched_stat* events. sched_switch events
contain correct call-chains and sched_stat contains a correct time
slices.

v2:
* Removed all known issues. Now it works completely.
* Improved usability of sched-stat scripts according with Arun's comments.
v3: fixed accoding to comments from David Ahem

Andrew Vagin (7):
  perf: use event_name() to get an event name
  perf: add ability to record event period
  perf: add ability to change event according to sample (v2)
  perf: teach "perf inject" to work with files
  perf: teach perf inject to merge sched_stat_* and sched_switch events
  perf: add scripts for profiling sleep times (v2)
  event: add tracepoint for accounting block time

 include/trace/events/sched.h                    |    7 ++
 kernel/sched_fair.c                             |    2 +
 tools/perf/builtin-inject.c                     |  120 ++++++++++++++++++++++-
 tools/perf/builtin-record.c                     |    5 +
 tools/perf/scripts/python/bin/sched-stat-record |   65 ++++++++++++
 tools/perf/scripts/python/bin/sched-stat-report |    5 +
 tools/perf/util/event.h                         |    2 +
 tools/perf/util/evsel.c                         |   74 ++++++++++++++
 tools/perf/util/header.c                        |    2 +-
 tools/perf/util/session.h                       |    9 ++
 10 files changed, 288 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report
