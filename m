Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab2FTIu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:50:58 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48940 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2FTIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:50:56 -0400
X-AuditID: 9c93016f-b7cbdae0000024ac-34-4fe18eed377a
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] libtraceevent fixes/improvements
Date: Wed, 20 Jun 2012 17:47:37 +0900
Message-Id: <1340182057-27497-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

Please pull libtraceevent fixes and improvements from my tree.
All patches in the tree got acked or signed-off by Steven and
contains proper Link tags you mentioned.

As this is my first pull request, I'm a bit afraid that I might
mess something up in the middle. Please do double-check. :)

Thanks,
Namhyung


The following changes since commit a78e5b82e99d8d284afc012ef015ef3332153aaf:

  perf hists browser: Implement printing snapshots to files (2012-06-07 19:31:28 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git tags/libtraceevent-core-for-acme

for you to fetch changes up to 16b470a46108d63c095fcfa5a3cf9252b41ae886:

  scripts/tags.sh: Teach [ce]tags about libtraceeevent error codes (2012-06-19 15:45:56 +0900)

----------------------------------------------------------------
tools lib traceevent: Error handling changes

* Remaining backport of libparseevent.
* Make pevent_parse_event returns custom error code.
* Introduce pevent_strerror for error report.

----------------------------------------------------------------
Namhyung Kim (15):
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
      tools lib traceevent: Replace malloc_or_die to plain calloc in alloc_event()
      tools lib traceevent: Do not link broken field arg for an old ftrace event
      tools lib traceevent: Introduce pevent_errno
      tools lib traceevent: Introduce pevent_strerror
      scripts/tags.sh: Teach [ce]tags about libtraceeevent error codes

Peter Huewe (1):
      tools lib traceevent: Add missing break in make_bprint_args

Steven Rostedt (4):
      tools lib traceevent: Let filtering numbers by string use function names
      tools lib traceevent: Add support for "%.*s" in bprintk events
      tools lib traceevent: Add support to show migrate disable counter
      tools lib traceevent: Fix %pM print format arg handling

Wolfgang Mauerer (1):
      tools lib traceevent: Fix trace_printk for long integers

 scripts/tags.sh                     |    6 +-
 tools/lib/traceevent/event-parse.c  |  385 ++++++++++++++++++++++++-----------
 tools/lib/traceevent/event-parse.h  |   34 +++-
 tools/lib/traceevent/parse-filter.c |   86 +++++---
 4 files changed, 360 insertions(+), 151 deletions(-)
