Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1IWU12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:27:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36632 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1IWU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:27:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com,
        arnaldo.melo@gmail.com
Subject: [GIT PULL 00/12] perf tools fixes
Date: Fri, 23 Sep 2011 17:26:14 -0300
Message-Id: <1316809586-28529-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

        Please consider pulling from:

  git://github.com/acmel/linux.git perf-tools-for-linus

	I was waiting to push it thru Ingo, but people are rightly complaining
these fixes should get into v3.1, so I asked Peter to take a look and he is OK
with sending them now to you.

	Please let me know of anything I may have messed up in putting together
this git repo/branch on github.

Regards,

- Arnaldo

The following changes since commit d93dc5c4478c1fd5de85a3e8aece9aad7bbae044

Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Sep 21 16:58:15 2011 -0700

    Linux 3.1-rc7

Anton Blanchard (6):
  perf symbols: Fix ppc64 SEGV in dso__load_sym with debuginfo files
  perf symbols: /proc/kallsyms does not sort module symbols
  perf symbols: Preserve symbol scope when parsing /proc/kallsyms
  perf symbols: Add some heuristics for choosing the best duplicate symbol
  perf symbols: Synthesize anonymous mmap events
  perf sort: Fix symbol sort output by separating unresolved samples by type

Arnaldo Carvalho de Melo (1):
  perf top: Fix userspace sample addr map offset

Darren Hart (1):
  perf tools: Add support for disabling -Werror via WERROR=0

David Ahern (2):
  perf record: Create events initially disabled and enable after init
  perf tool: Fix endianness handling of u32 data in samples

Masami Hiramatsu (1):
  perf probe: Fix regression of variable finder

Stephane Eranian (1):
  perf symbols: Fix issue with binaries using 16-bytes buildids (v2)

 tools/perf/Makefile            |    9 ++-
 tools/perf/builtin-record.c    |    3 +
 tools/perf/builtin-test.c      |    2 +-
 tools/perf/builtin-top.c       |    9 ++-
 tools/perf/util/event.c        |    5 ++
 tools/perf/util/event.h        |    2 +-
 tools/perf/util/evlist.c       |   13 ++++
 tools/perf/util/evlist.h       |    1 +
 tools/perf/util/evsel.c        |   54 +++++++++++---
 tools/perf/util/probe-finder.c |    2 +-
 tools/perf/util/session.h      |    3 +-
 tools/perf/util/sort.c         |   10 ++-
 tools/perf/util/symbol.c       |  153 +++++++++++++++++++++++++++++++---------
 13 files changed, 209 insertions(+), 57 deletions(-)

