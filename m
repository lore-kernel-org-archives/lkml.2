Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab2HPRpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 13:45:35 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52289 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756565Ab2HPRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 13:45:33 -0400
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH -v2 0/4] Persistent events
Date: Thu, 16 Aug 2012 19:45:19 +0200
Message-Id: <1345139123-15212-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.11.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

off and on I get some free time to work on that, here's the latest
incarnation. It contains review feedback from the earlier round.

Patch 1/4 adds a trace_add_file() interface which adds an additional
file to debugfs, in this case the "persistent" file which contains the
normal perf file descriptor sys_perf_event_open gives to the perf tool.

IOW, one gets:

/mnt/dbg/tracing/events/mce/mce_record/
|-- enable
|-- filter
|-- format
|-- id
`-- persistent1

0 directories, 5 files

 [ 1 is the CPU number so sticking all per-CPU descriptors in this
 directory could get a little cluttered and ugly so I'll have to think
 about that a bit more. ]

3/4 is the meat which adds <kernel/events/persistent.c> and 4/4 shows
how one can init a persistent event on a CPU.

What remains is adding code which can enable events on boot from the
kernel cmdline and more testing.

As always, comments and suggestions are appreciated.

Thanks.

Borislav Petkov (4):
  trace events: Interface to add files to debugfs
  perf: Add persistent events
  perf: Add persistent event facilities
  persistent test

 arch/x86/include/asm/mce.h       |   1 +
 arch/x86/kernel/cpu/mcheck/mce.c |   5 ++
 include/linux/ftrace_event.h     |   3 +
 include/linux/perf_event.h       |  24 +++++-
 kernel/events/Makefile           |   2 +-
 kernel/events/core.c             |  18 +++--
 kernel/events/internal.h         |   2 +
 kernel/events/persistent.c       | 168 +++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c             |   4 +
 kernel/trace/trace.h             |   1 +
 kernel/trace/trace_events.c      |  35 ++++++++
 11 files changed, 254 insertions(+), 9 deletions(-)
 create mode 100644 kernel/events/persistent.c

-- 
1.7.11.rc1

