Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0CPV5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:57:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab0CPV5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:57:39 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 00/10] perf-probe updates - data-structure support, etc.
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 16 Mar 2010 18:05:15 -0400
Message-ID: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several updates of perf-probe.
This updates includes data structure accessing support
--list option enhancement and --dry-run option support.

- --dry-run allows users to run perf-probe just for checking
  that the command works correctly.

- --list option enhancement allows user to check where the
  probes are put on (with filename/line number).

- data structure accessing support allows user to trace
  the contents of local variables/function parameters.

Long-term TODOs (future features):
  - Enhance probe-finder to decode call frame instructions.
  - Support tracing static variables (non global)
  - Support variable basic types from debuginfo (e.g. char, int, ...)
  - Support array element (var[N])
  - Support string/dynamic arrays (*var, var[N..M])
  - Support the type of return value
  - Support force type-casting ((type)var)
  - Support sys_perf_counter_open (for non-root users)
  - Support dynamic array-indexing (var[var2])

Miscs:
  - Better support for probes on modules
  - More debugger like enhancements(%next, --disasm, etc.)


Thank you,

---

Masami Hiramatsu (10):
      perf probe: Accessing members in data structures
      perf probe: List probes with line number and file name
      perf probe: Introduce kprobe_trace_event and perf_probe_event
      perf probe: Add --dry-run option
      perf probe: Introduce die_find_child() function
      perf probe: Rename some die_get_* functions
      perf probe: Rename session to param
      perf probe: Move add-probe routine under util/
      perf probe: Use wrapper functions
      perf tools: Introduce xzalloc() for detecting out of memory


 tools/perf/Documentation/perf-probe.txt |    5 
 tools/perf/builtin-probe.c              |  191 +------
 tools/perf/util/probe-event.c           |  830 +++++++++++++++++++++++--------
 tools/perf/util/probe-event.h           |  123 ++++-
 tools/perf/util/probe-finder.c          |  459 ++++++++++++-----
 tools/perf/util/probe-finder.h          |   60 +-
 tools/perf/util/util.h                  |    7 
 7 files changed, 1115 insertions(+), 560 deletions(-)

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
