Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab2GYRmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 13:42:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:45553 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2GYRmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 13:42:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arun Sharma <asharma@fb.com>,
        Benjamin Redelings <benjamin.redelings@nescent.org>,
        Cody Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, David Ahern <dsahern@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Jovi Zhang <bookjovi@gmail.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Tom Zanussi <tzanussi@gmail.com>, Ulrich Drepper <drepper@gmail.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/19] perf/core fixes and improvements
Date: Wed, 25 Jul 2012 14:41:15 -0300
Message-Id: <1343238094-12481-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling,

Best Regards,

- Arnaldo

The following changes since commit 6e0f17be0361444862637e8986c8c1a3b3f8dcf8:

  Merge branch 'tip/perf/core' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace into perf/core (2012-07-18 11:18:00 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 8696329b7bcf32e69ad12d5975ad1497936d43ec:

  perf annotate: Prevent overflow in size calculation (2012-07-25 13:06:42 -0300)

----------------------------------------------------------------
perf/core fixes and improvements:

. libtraceevent build fixes from Namhyung Kim

. Prevent overflow when calculating annotation buckets size, from Cody Schafer

. Set breakpoint events sample period to 1, just like trace events, from Jovi Zhang

. Fix strerror_r usage, from Kirill Shutemov

. Fix duplicate function declaration problems with bison 2.6, from Kirill Shutemov

. Add DSO caching facility (and perf test entry) to speed up binary file
  reading, will be used by the DWARF unwind code, from Jiri Olsa

. Fix trace event storms by setting PERF_SAMPLE_PERIOD, from Frederic Weisbecker

. perf kvm fixes from David Ahern

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Cody Schafer (1):
      perf annotate: Prevent overflow in size calculation

David Ahern (6):
      perf symbols: Add machine id to modules debug message
      perf kvm: Set name for VM process in guest machine
      perf kvm: Guest userspace samples should not be lumped with host uspace
      perf kvm: Fix bug resolving guest kernel syms
      perf kvm: Limit repetitive guestmount message to once per directory
      perf tools: Dump exclude_{guest,host}, precise_ip header info too

Frederic Weisbecker (3):
      perf hists: Return correct number of characters printed in callchain
      perf tools: Fix trace events storms due to weight demux
      perf hists: Print newline between hists callchains

Jiri Olsa (4):
      perf symbols: Factor DSO symtab types to generic binary types
      perf symbols: Add interface to read DSO image data
      perf symbols: Add dso data caching
      perf test: Add dso data caching tests

Jovi Zhang (1):
      perf tools: Make the breakpoint events sample period default to 1

Kirill A. Shutemov (2):
      perf tools: use XSI-complaint version of strerror_r() instead of GNU-specific
      perf tools: Fix build error with bison 2.6

Namhyung Kim (2):
      tools lib traceevent: Detect build environment changes
      tools lib traceevent: Ignore TRACEEVENT-CFLAGS file

 tools/lib/traceevent/.gitignore |    1 +
 tools/lib/traceevent/Makefile   |   14 +-
 tools/perf/Makefile             |    4 +
 tools/perf/builtin-test.c       |    4 +
 tools/perf/builtin-top.c        |    2 +-
 tools/perf/ui/browsers/hists.c  |    4 +-
 tools/perf/util/annotate.c      |   15 +-
 tools/perf/util/dso-test-data.c |  153 ++++++++++++++
 tools/perf/util/evlist.c        |    2 +-
 tools/perf/util/header.c        |    6 +
 tools/perf/util/hist.c          |    7 +-
 tools/perf/util/map.c           |   41 +++-
 tools/perf/util/map.h           |    1 +
 tools/perf/util/parse-events.c  |    2 +
 tools/perf/util/session.c       |    5 +-
 tools/perf/util/symbol.c        |  447 +++++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.h        |   54 +++--
 tools/perf/util/target.c        |   11 +-
 18 files changed, 657 insertions(+), 116 deletions(-)
 create mode 100644 tools/lib/traceevent/.gitignore
 create mode 100644 tools/perf/util/dso-test-data.c
