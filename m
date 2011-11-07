Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1KGMyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:54:07 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:21444 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab1KGMyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:54:05 -0500
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 0/7] Profiling sleep times (v2)
Date: Mon,  7 Nov 2011 15:54:10 +0300
Message-Id: <1320670457-2633428-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Andrew Vagin (7):
  perf: use event_name() to get an event name
  event: don't divide events if it has field period
  perf: add ability to record event period
  perf: add ability to change event according to sample
  perf: teach "perf inject" to work with files
  perf: teach perf inject to merge sched_stat_* and sched_switch events
  perf: add scripts for profiling sleep times

 kernel/events/core.c                            |    7 +-
 tools/perf/builtin-inject.c                     |  120 ++++++++++++++++++++++-
 tools/perf/builtin-record.c                     |    5 +
 tools/perf/scripts/python/bin/sched-stat-record |   65 ++++++++++++
 tools/perf/scripts/python/bin/sched-stat-report |    5 +
 tools/perf/util/event.h                         |    2 +
 tools/perf/util/evsel.c                         |   74 ++++++++++++++
 tools/perf/util/header.c                        |    2 +-
 tools/perf/util/session.h                       |    9 ++
 9 files changed, 285 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report
