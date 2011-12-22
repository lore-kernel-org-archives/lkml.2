Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab1LVAPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:15:54 -0500
Received: from intmgw001.ash2.facebook.com ([66.220.155.178]:48473 "EHLO
	intmgw001.ash2.facebook.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753163Ab1LVAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:15:52 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH] Sleep Profiling v3
Date: Wed, 21 Dec 2011 16:15:39 -0800
Message-Id: <1324512940-32060-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:

* Zero {block,sleep}_start after reading them
* Fix trailing whitespace

Changes since v1:

* Define a new sched_stat tracepoint
* Rebased to -tip

When debugging latency, users want to know where their code
is executing on the CPU (cycle profiling) as well as where
it's waiting sleeping or waiting for IO. The following patch set
tries to address the latter.

Normal users can use this tracepoint without root privileges
and on a system with lots of context switches, load can be
reduced by filtering out uninteresting switches.

Sample command lines:

perf record -gPe sched:sched_stat_sleeptime --filter "sleeptime > 10000" -- ./test
perf report --stdio -g graph -G

Arun Sharma (1):
  tracing, sched: Add a new tracepoint for sleeptime

 include/trace/events/sched.h |   50 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c          |    1 +
 kernel/sched/fair.c          |    2 -
 3 files changed, 51 insertions(+), 2 deletions(-)

-- 
1.7.4

