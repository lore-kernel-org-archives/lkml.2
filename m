Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab1LGN6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:58:40 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:34416 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1LGN6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:58:37 -0500
From: Andrew Vagin <avagin@openvz.org>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@elte.hu, asharma@fb.com, devel@openvz.org, dsahern@gmail.com,
        linux-perf-users@vger.kernel.org
Subject: [PATCH 0/7] Profiling sleep times (v4)
Date: Wed,  7 Dec 2011 16:55:55 +0300
Message-Id: <1323266161-394927-1-git-send-email-avagin@openvz.org>
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
v4: rebase to linux-tip

Andrew Vagin (6):
  perf: use event_name() to get an event name
  perf: add ability to change event according to sample (v3)
  perf: add ability to record event period
  perf: teach "perf inject" to work with files
  perf: teach perf inject to merge sched_stat_* and sched_switch events
  perf: add scripts for profiling sleep times (v2)

 tools/perf/builtin-inject.c                     |  132 +++++++++++++++++++++--
 tools/perf/builtin-record.c                     |    1 +
 tools/perf/perf.h                               |    1 +
 tools/perf/scripts/python/bin/sched-stat-record |   65 +++++++++++
 tools/perf/scripts/python/bin/sched-stat-report |    5 +
 tools/perf/util/event.h                         |    2 +
 tools/perf/util/evsel.c                         |   77 +++++++++++++
 tools/perf/util/header.c                        |    2 +-
 tools/perf/util/session.h                       |    9 ++
 9 files changed, 286 insertions(+), 8 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report
