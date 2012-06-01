Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965821Ab2FAWRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:17:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:59533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965792Ab2FAWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Avik Sil <avik.sil@linaro.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Sunjin Yang <fan4326@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-perf-users@vger.kernel.org
Subject: [GIT PULL 00/15] perf/urgent fixes
Date: Fri,  1 Jun 2012 19:16:24 -0300
Message-Id: <1338588999-32509-1-git-send-email-acme@infradead.org>
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

	Please consider pulling, this is in addition to what already were in
perf/urgent.

- Arnaldo

The following changes since commit 79695e1bb65ba0e21488c360a1bed6e358354aaa:

  perf stat: Initialize default events wrt exclude_{guest,host} (2012-05-30 14:02:38 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-urgent-for-mingo

Arnaldo Carvalho de Melo (2):
      perf tools: Fix make tarballs
      perf tools: Make --version show kernel version instead of pull req tag

Avik Sil (1):
      perf tools: Fix pager on minimal-install embedded systems

David Ahern (2):
      perf script: Fix regression in callchain dso name
      perf tool: Build fix, remove duplicate declarations

Jiri Olsa (3):
      perf symbols: Handle different endians properly during symbol load
      perf session: Handle endianity swap on sample_id_all header data
      perf evsel: Fix 32 bit values endianity swap for sample_id_all header

Namhyung Kim (5):
      perf callchain: Make callchain cursors TLS
      perf tools: Check if callchain is corrupted
      perf tools: Update ioctl documentation for PERF_IOC_FLAG_GROUP
      perf evlist: Pass third argument to ioctl explicitly
      perf: Remove duplicate invocation on perf_event_for_each

Srikar Dronamraju (2):
      perf symbols: Check for valid dso before creating map
      perf uprobes: Remove unnecessary check before strlist__delete

 include/linux/perf_event.h       |    4 +-
 kernel/events/core.c             |    1 -
 tools/perf/MANIFEST              |    2 +
 tools/perf/builtin-report.c      |    2 +-
 tools/perf/builtin-top.c         |    2 +-
 tools/perf/design.txt            |    7 ++-
 tools/perf/util/PERF-VERSION-GEN |    2 +-
 tools/perf/util/callchain.c      |    2 +
 tools/perf/util/callchain.h      |    2 +
 tools/perf/util/evlist.c         |    6 ++-
 tools/perf/util/evsel.c          |   29 +++++++++---
 tools/perf/util/hist.c           |    7 ++-
 tools/perf/util/hist.h           |    2 -
 tools/perf/util/pager.c          |    4 ++
 tools/perf/util/probe-event.c    |    8 +--
 tools/perf/util/session.c        |   97 +++++++++++++++++++++++++++++--------
 tools/perf/util/symbol.c         |   38 ++++++++++++++-
 tools/perf/util/symbol.h         |   34 ++++++++++++-
 tools/perf/util/util.h           |    6 +--
 19 files changed, 195 insertions(+), 60 deletions(-)
