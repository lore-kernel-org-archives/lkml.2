Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1KBW7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 18:59:46 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24631 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1KBW7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 18:59:44 -0400
From: Andrew Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, avagin@openvz.org,
        devel@openvz.org
Subject: [PATCH 0/4] Profiling sleep times
Date: Thu,  3 Nov 2011 01:59:40 +0300
Message-Id: <1320274784-2463901-1-git-send-email-avagin@openvz.org>
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

Known issues:
Now some samples may be lost due to throttling. The number of samples is
restricted by sysctl_perf_event_sample_rate/HZ.  A trace event is divided on
some samples according to event's period.  I don't sure, that we should
generate more than one sample on each trace event. I think the better way to
use SAMPLE_PERIOD and now I think in this direction.
This problem isn't in my patches, so you can review it, while I'm working on
this issue.

Andrew Vagin:
  perf: teach "perf inject" to work with files
  perf: teach perf inject to merge sched_stat_* and sched_switch events
  perf: add scripts for profiling sleep times

 tools/perf/builtin-inject.c                     |  120 ++++++++++++++++++++++-
 tools/perf/scripts/python/bin/sched-stat-record |    2 +
 tools/perf/scripts/python/bin/sched-stat-report |    6 +
 3 files changed, 126 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-record
 create mode 100644 tools/perf/scripts/python/bin/sched-stat-report

