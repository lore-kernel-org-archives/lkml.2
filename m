Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0HBANU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:20 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0HBANT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=fVOBnJyd7WWbxxEZMjIt64/+BfPip3kNbPTIjSbq7G3Qi6BOHLAkZKx/tprJcwg44/
         TFR3XhiwoOmzZAq2Lja5bnaHnS5TAf8fNNusjMMbai+TuCSEipaRQeFky3zzYQjQxK6e
         Bglkv3pkx9/goY0CihvRhisQwe++fj6VyhtVA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] instrumentation updates
Date: Mon,  2 Aug 2010 02:13:01 +0200
Message-Id: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/core branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/core


A large part is about the new "perf sched migration". It still needs
improvements, like fixing some zoom issues, handling sched policies
and nice levels, etc...

But at least it's usable for general overviews of CPUs load
distribution.

Thanks,
	Frederic
---

Frederic Weisbecker (9):
      perf: Use tracepoint_synchronize_unregister() to flush any pending tracepoint call
      tracing: Drop cpparg() macro
      perf: New migration tool overview
      perf, sched migration: Handle ignored migrate out events
      perf, sched migration: Ignore unhandled task states
      perf, sched migration: Make it vertically scrollable
      perf, sched migration: Make the GUI class client agnostic
      perf, sched migration: Librarize the GUI class
      perf, sched migration: Librarize task states and event headers helpers

Nikhil Rao (2):
      perf, sched migration: Fix key bindings
      perf, sched migration: Parameterize cpu height and spacing

Marcin Slusarz (1):
      x86,mmiotrace: Add support for tracing STOS instruction


 arch/x86/mm/pf_in.c                                |   30 +-
 include/trace/ftrace.h                             |    7 +-
 kernel/trace/trace_event_perf.c                    |    6 +-
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   30 ++
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |  184 ++++++++
 .../perf/scripts/python/bin/sched-migration-record |    2 +
 .../perf/scripts/python/bin/sched-migration-report |    3 +
 tools/perf/scripts/python/sched-migration.py       |  461 ++++++++++++++++++++
 8 files changed, 702 insertions(+), 21 deletions(-)
