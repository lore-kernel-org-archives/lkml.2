Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab2GEPqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:46:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32987 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab2GEPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:46:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ulrich Drepper <drepper@gmail.com>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>,
        arnaldo.melo@gmail.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [GIT PULL 00/20] perf/core improvements and fixes
Date: Thu,  5 Jul 2012 12:44:58 -0300
Message-Id: <1341503118-13198-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, this one contains my first merge, a pull
request by Namhyung, please check if everything is OK,

Thanks,

- Arnaldo

The following changes since commit 17d7a1123f0f6d532830152564cc812cc73db2f3:

  perf bench: Fix confused variable namings and descriptions in mem subsystem (2012-07-02 14:35:45 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 81e9b994bb20716d1f6c47e048e4ae4a43de2f83:

  Merge tag 'libtraceevent-core-for-acme' of git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf into perf/core (2012-07-05 12:16:32 -0300)

----------------------------------------------------------------

perf/core improvements and fixes:

. Preparatory patches to use hw events in PMU syntax, from Jiri Olsa

. Remaining backport of trace-cmd's libparseevent, from Namhyung Kim

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Arnaldo Carvalho de Melo (1):
      Merge tag 'libtraceevent-core-for-acme' of git://git.kernel.org/.../namhyung/linux-perf into perf/core

Jiri Olsa (4):
      perf test: Use ARRAY_SIZE in parse events tests
      perf tools: Add empty rule for new line in event syntax parsing
      perf tools: Split out PE_VALUE_SYM parsing token to SW and HW tokens
      perf tools: Split event symbols arrays to hw and sw parts

Namhyung Kim (10):
      tools lib traceevent: Fix printk_cmp()
      tools lib traceevent: Introduce extend_token()
      tools lib traceevent: Handle strdup failure cases
      tools lib traceevent: Handle realloc() failure path
      tools lib traceevent: Pass string type argument to args
      tools lib traceevent: Do not call add_event() again if allocation failed
      tools lib traceevent: Fix some comments
      tools lib traceevent: Check result of malloc() during reading token
      tools lib traceevent: Check return value of arg_to_str()
      tools lib traceevent: Cleanup realloc use

Peter Huewe (1):
      tools lib traceevent: Add missing break in make_bprint_args

Steven Rostedt (4):
      tools lib traceevent: Let filtering numbers by string use function names
      tools lib traceevent: Add support for "%.*s" in bprintk events
      tools lib traceevent: Add support to show migrate disable counter
      tools lib traceevent: Fix %pM print format arg handling

Wolfgang Mauerer (1):
      tools lib traceevent: Fix trace_printk for long integers

 tools/lib/traceevent/event-parse.c  |  287 +++++++++++++++++++++++------------
 tools/lib/traceevent/parse-filter.c |   86 +++++++----
 tools/perf/util/parse-events-test.c |   29 ++--
 tools/perf/util/parse-events.c      |  174 ++++++++++++++-------
 tools/perf/util/parse-events.l      |    3 +-
 tools/perf/util/parse-events.y      |   15 +-
 6 files changed, 391 insertions(+), 203 deletions(-)
