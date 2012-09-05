Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab2IEXJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:09:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51617 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2IEXJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:09:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "Ananth N. Mavinakayanahalli" <ananth@in.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Maciek Borzecki <maciek.borzecki@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/17] perf/core improvements and fixes
Date: Wed,  5 Sep 2012 20:08:40 -0300
Message-Id: <1346886537-11621-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit bab57e994d6311298b4e3915d2c75296cd81638c:

  Merge branch 'core' of git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile into perf/core (2012-09-05 08:29:56 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 7a4ec938857cf534270b23545495300fbac7f5de:

  perf tools: Allow user to indicate path to objdump in command line (2012-09-05 19:41:55 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

1) Rename libtraceevent 'private' struct member to 'priv' so that it works
   in C++, from Steven Rostedt

2) Remove lots of exit()/die() calls from tools so that the main perf exit
   routine can take place, from David Ahern

3) Fix x86 build on x86-64, from David Ahern.

4) Remove some headers that prevented perf from building on Android,
   from David Ahern

5) {int,str,rb}list fixes from Suzuki K Poulose

6) perf.data header fixes from Namhyung Kim

7) Replace needless mempcpy with memcpy, to allow build on Android, from Irina Tirdea

8) Allow user to indicate objdump path, needed in cross environments, from
   Maciek Borzecki

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
David Ahern (9):
      perf session: flush_sample_queue needs to handle errors from handlers
      perf tool: handle errors in synthesized event functions
      perf lock: Remove use of die and handle errors
      perf stat: Remove use of die/exit and handle errors
      perf help: Remove use of die and handle errors
      perf script: Remove use of die/exit
      perf record: Remove use of die/exit
      perf tools: Fix x86 builds with ARCH specified on the command line
      perf tools: remove unneeded include of network header files

Irina Tirdea (1):
      perf tools: Replace mempcpy with memcpy

Maciek Borzecki (1):
      perf tools: Allow user to indicate path to objdump in command line

Namhyung Kim (3):
      perf header: Use evlist->nr_entries on write_event_desc()
      perf header: Set tracepoint event name only if not set
      perf header: Swap pmu mapping numbers if needed

Steven Rostedt (1):
      tools lib traceevent: Modify header to work in C++ programs

Suzuki K. Poulose (2):
      perf tools: Fix intlist node removal
      perf tools: Remove the node from rblist in strlist__remove

 tools/lib/traceevent/event-parse.h                 |    4 +-
 tools/perf/Documentation/perf-annotate.txt         |    3 +
 tools/perf/Documentation/perf-report.txt           |    3 +
 tools/perf/Makefile                                |    4 +-
 tools/perf/builtin-annotate.c                      |    2 +
 tools/perf/builtin-help.c                          |   48 ++++--
 tools/perf/builtin-lock.c                          |  181 ++++++++++++++------
 tools/perf/builtin-record.c                        |  158 +++++++++++------
 tools/perf/builtin-report.c                        |    2 +
 tools/perf/builtin-script.c                        |   60 +++++--
 tools/perf/builtin-stat.c                          |    7 +-
 tools/perf/util/annotate.c                         |    4 +-
 tools/perf/util/annotate.h                         |    1 +
 tools/perf/util/event.c                            |   35 +++-
 tools/perf/util/header.c                           |   13 +-
 tools/perf/util/intlist.c                          |    4 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    8 +-
 tools/perf/util/session.c                          |   24 ++-
 tools/perf/util/strlist.c                          |    2 +-
 tools/perf/util/target.c                           |    4 +-
 tools/perf/util/util.h                             |    5 -
 21 files changed, 389 insertions(+), 183 deletions(-)
