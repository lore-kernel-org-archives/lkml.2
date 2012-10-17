Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab2JQRWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:22:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:46087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab2JQRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:13 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Avi Kivity <avi@redhat.com>, David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Irina Tirdea <irina.tirdea@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/11] perf/urgent fixes
Date: Wed, 17 Oct 2012 14:19:36 -0300
Message-Id: <1350494387-10987-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 95cf59ea72331d0093010543b8951bb43f262cac:

  perf: Fix perf_cgroup_switch for sw-events (2012-10-05 13:59:07 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

for you to fetch changes up to 88a21d2f07d2a4bec2e3e03dd50a39683b938b10:

  perf hists browser: Add back callchain folding symbol (2012-10-17 13:54:08 -0300)

----------------------------------------------------------------
perf/urgent fixes:

. The python binding needs to link with libtraceevent and to initialize
  the 'page_size' variable so that mmaping works again.

. The callchain folding character that appears on the TUI just before
  the overhead had disappeared due to recent changes, add it back.

. Intel PEBS in VT-x context uses the DS address as a guest linear address,
  even though its programmed by the host as a host linear address. This either
  results in guest memory corruption and or the hardware faulting and 'crashing'
  the virtual machine.  Therefore we have to disable PEBS on VT-x enter and
  re-enable on VT-x exit, enforcing a strict exclude_guest.

  Kernel side enforcement fix by Peter Zijlstra, tooling side fix by David Ahern.

. Fix build on sparc due to UAPI, fix from David Miller.

. Fixes for the srclike sort key for unresolved symbols and when processing
  samples in JITted code, where we don't have an ELF file, just an special
  symbol table, fixes from Namhyung Kim.

. Fix some leaks in libtraceevent, from Steven Rostedt.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (3):
      perf python: Initialize 'page_size' variable
      perf python: Link with libtraceevent
      perf hists browser: Add back callchain folding symbol

David Ahern (1):
      perf tool: Precise mode requires exclude_guest

David Miller (1):
      perf tools: Fix build on sparc.

Namhyung Kim (3):
      perf tools: Fix segfault when using srcline sort key
      perf tools: Remove warnings on JIT samples for srcline sort key
      perf hists browser: Fix off-by-two bug on the first column

Peter Zijlstra (1):
      perf: Require exclude_guest to use PEBS - kernel side enforcement

Steven Rostedt (2):
      lib tools traceevent: Add back pevent assignment in __pevent_parse_format()
      tools lib traceevent: Fix missed freeing of subargs in free_arg() in filter

 arch/x86/kernel/cpu/perf_event.c    |    6 ++++++
 tools/lib/traceevent/event-parse.c  |    9 ++++++---
 tools/lib/traceevent/parse-filter.c |   15 +++++++++++++++
 tools/perf/perf.h                   |    2 +-
 tools/perf/ui/browsers/hists.c      |    6 ++++--
 tools/perf/util/parse-events.c      |    3 +++
 tools/perf/util/python.c            |    2 ++
 tools/perf/util/setup.py            |    1 +
 tools/perf/util/sort.c              |    6 ++++++
 9 files changed, 44 insertions(+), 6 deletions(-)
