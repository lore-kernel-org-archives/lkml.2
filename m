Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2IXQCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:02:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:41485 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729Ab2IXQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Avi Kivity <avi@redhat.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Eric Sandeen <sandeen@redhat.com>, Feng Tang <feng.tang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Irina Tirdea <irina.tirdea@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Frysinger <vapier@gentoo.org>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/30] perf/core improvements and fixes
Date: Mon, 24 Sep 2012 12:59:14 -0300
Message-Id: <1348502384-14442-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

- Arnaldo

The following changes since commit 1e6dd8adc78d4a153db253d051fd4ef6c49c9019:

  perf: Fix off by one test in perf_reg_value() (2012-09-19 17:08:40 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to b1ac754b67b5a875d63bee880f60ccb0c6bd8899:

  tools lib traceevent: Handle alloc_arg failure (2012-09-24 12:31:52 -0300)

----------------------------------------------------------------
perf/core improvements and fixes:

. Convert the trace builtins to use the growing evsel/evlist
  tracepoint infrastructure, removing several open coded constructs
  like switch like series of strcmp to dispatch events, etc.
  Basically what had already been showcased in 'perf sched'.

. Add evsel constructor for tracepoints, that uses libtraceevent
  just to parse the /format events file, use it in a new 'perf test'
  to make sure the libtraceevent format parsing regressions can
  be more readily caught.

. Some strange errors were happening in some builds, but not on the
  next, reported by several people, problem was some parser related
  files, generated during the build, didn't had proper make deps,
  fix from Eric Sandeen.

. Fix some compiling errors on 32-bit, from Feng Tang.

. Don't use sscanf extension %as, not available on bionic, reimplementation
  by Irina Tirdea.

. Fix bfd.h/libbfd detection with recent binutils, from Markus Trippelsdorf.

. Introduce struct and cache information about the environment where a
  perf.data file was captured, from Namhyung Kim.

. Fix several error paths in libtraceevent, from Namhyung Kim.

  Print event causing perf_event_open() to fail in 'perf record',
  from Stephane Eranian.

. New 'kvm' analysis tool, from Xiao Guangrong.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (11):
      perf kvm: Use perf_evsel__intval
      perf kmem: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
      perf lock: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
      perf timechart: Use zalloc and fix a couple leaks
      tools lib traceevent: Use asprintf were applicable
      tools lib traceevent: Use calloc were applicable
      tools lib traceevent: Fix afterlife gotos
      tools lib traceevent: Remove some die() calls
      tools lib traceevent: Carve out events format parsing routine
      perf evsel: Provide a new constructor for tracepoints
      perf test: Add test for the sched tracepoint format fields

Eric Sandeen (1):
      perf tools: Fix parallel build

Feng Tang (2):
      perf tools: Fix a compiling error in trace-event-perl.c for 32 bits machine
      perf tools: Fix a compiling error in util/map.c

Irina Tirdea (1):
      perf tools: remove sscanf extension %as

Markus Trippelsdorf (1):
      perf tools: bfd.h/libbfd detection fails with recent binutils

Namhyung Kim (11):
      perf header: Add struct perf_session_env
      perf header: Add ->process callbacks to most of features
      perf header: Use pre-processed session env when printing
      perf header: Remove unused @feat arg from ->process callback
      perf kvm: Use perf_session_env for reading cpuid
      perf header: Remove perf_header__read_feature
      tools lib traceevent: Fix error path on process_array()
      tools lib traceevent: Make sure that arg->op.right is set properly
      tools lib traceevent: Free field if an error occurs on process_fields
      tools lib traceevent: Free field if an error occurs on process_flags/symbols
      tools lib traceevent: Handle alloc_arg failure

Stephane Eranian (1):
      perf record: Print event causing perf_event_open() to fail

Xiao Guangrong (2):
      KVM: x86: Export svm/vmx exit code and vector code to userspace
      perf kvm: Events analysis tool

 arch/x86/include/asm/kvm.h                         |   16 +
 arch/x86/include/asm/kvm_host.h                    |   16 -
 arch/x86/include/asm/svm.h                         |  205 +++--
 arch/x86/include/asm/vmx.h                         |  127 ++-
 arch/x86/kvm/trace.h                               |   89 ---
 tools/lib/traceevent/event-parse.c                 |  570 +++++++++----
 tools/lib/traceevent/event-parse.h                 |    3 +
 tools/perf/Documentation/perf-kvm.txt              |   30 +-
 tools/perf/MANIFEST                                |    3 +
 tools/perf/Makefile                                |    6 +-
 tools/perf/builtin-kmem.c                          |   90 +--
 tools/perf/builtin-kvm.c                           |  836 +++++++++++++++++++-
 tools/perf/builtin-lock.c                          |  233 ++----
 tools/perf/builtin-record.c                        |    6 +-
 tools/perf/builtin-test.c                          |   86 ++
 tools/perf/builtin-timechart.c                     |   40 +-
 tools/perf/util/evsel.c                            |   88 ++-
 tools/perf/util/evsel.h                            |    5 +
 tools/perf/util/header.c                           |  547 +++++++++----
 tools/perf/util/header.h                           |   24 +
 tools/perf/util/map.c                              |    5 +-
 tools/perf/util/probe-event.c                      |   36 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 tools/perf/util/symbol.h                           |    1 +
 tools/perf/util/thread.h                           |    2 +
 tools/perf/util/trace-event-parse.c                |   18 +-
 26 files changed, 2278 insertions(+), 806 deletions(-)
