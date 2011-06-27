Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488Ab1F1MCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:02:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54164 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1F1L5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:57:01 -0400
X-AuditID: b753bd60-a1ec5ba000003bac-2a-4e09c18acb05
X-AuditID: b753bd60-a1ec5ba000003bac-2a-4e09c18acb05
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  00/13]tracing/kprobes: Dynamic events on module support
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 27 Jun 2011 16:26:26 +0900
Message-ID: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Here, I'd like to push updates of dynamic events and perf-probe
for supporting dynamic events on module.

The main part of this series is 1-5th patches for kprobes and
dynamic event tracer, which allows us to add events on offline
kernel module. This means we can put events even on the init
functions of the drivers before loading. The requirement of
this feature comes from my recent experience of a driver
debugging. It had a timing bug in the initialization routine,
and it was hard to catch them without tracing the behavior.

I added some perf-probe updates (which including some resent
patches), And it's OK to pull only the main part (kprobes and
ftrace patches) without perf updates.


Thank you,

---

Masami Hiramatsu (13):
      perf probe: Support adding probes on offline kernel modules
      perf probe: Add probed module in front of function
      [RESEND]perf probe: Introduce debuginfo to encapsulate dwarf information
      [RESEND]perf probe: Warn when more than two lines are given
      [RESEND][CLEANUP]perf-probe: Move dwarf library routines to dwarf-aux.{c,h}
      [RESEND][CLEANUP]perf probe: Remove redundant dwarf functions
      [RESEND][CLEANUP]perf probe: Move strtailcmp to string.c
      [RESEND][CLEANUP]perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
      tracing/kprobe: Update symbol reference when loading module
      tracing/kprobes: Support module init function probing
      kprobes: Return -ENOENT if probe point doesn't exist
      [CLEANUP]tracing/kprobes: merge trace probe enable/disable functions
      [CLEANUP]tracing/kprobes: Rename probe_* to trace_probe_*


 Documentation/trace/kprobetrace.txt     |    9 
 kernel/kprobes.c                        |   33 +
 kernel/trace/trace_kprobe.c             |  314 +++++++++----
 tools/perf/Documentation/perf-probe.txt |    6 
 tools/perf/Makefile                     |    2 
 tools/perf/builtin-probe.c              |   14 -
 tools/perf/util/dwarf-aux.c             |  663 +++++++++++++++++++++++++++
 tools/perf/util/dwarf-aux.h             |  100 ++++
 tools/perf/util/probe-event.c           |  165 +++++--
 tools/perf/util/probe-event.h           |    1 
 tools/perf/util/probe-finder.c          |  752 ++++---------------------------
 tools/perf/util/probe-finder.h          |   43 +-
 tools/perf/util/string.c                |   19 +
 tools/perf/util/util.h                  |    1 
 14 files changed, 1304 insertions(+), 818 deletions(-)
 create mode 100644 tools/perf/util/dwarf-aux.c
 create mode 100644 tools/perf/util/dwarf-aux.h

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

