Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641Ab2HHROK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:14:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:45879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030592Ab2HHROH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Feng Tang <feng.tang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com
Subject: [GIT PULL 00/11] perf/core improvements and fixes
Date: Wed,  8 Aug 2012 14:13:37 -0300
Message-Id: <1344446028-21381-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling, on top of my latest pull request,

- Arnaldo

-- 
1.7.9.2.358.g22243

The following changes since commit 9782243353ec135327a80c76c63464e592949cd1:

  perf script: Stop using pevent directly (2012-08-07 23:50:21 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux tags/perf-core-for-mingo

for you to fetch changes up to 0076d546b4f9b5c15121c6959d108a83fe43fa9a:

  perf scripts python: Add event_analyzing_sample.py as a sample for general event handling (2012-08-08 12:55:38 -0300)

----------------------------------------------------------------
perf/core improvements

. Assorted fixes for Documentation and build in 32 bit, from Robert Richter

. Add support for non-tracepoint events in perf script python, from Feng Tang

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

----------------------------------------------------------------
Feng Tang (5):
      perf script: Add general python handler to process non-tracepoint events
      perf script: Replace "struct thread" with "struct addr_location" as a parameter for "process_event()"
      perf scripts python: Pass event/thread/dso name and symbol info to event handler in python
      perf scripts python: Add a python library EventClass.py
      perf scripts python: Add event_analyzing_sample.py as a sample for general event handling

Robert Richter (6):
      perf tools: Fix version file for perf documentation with OUTPUT variable set
      perf tools: Fix lib/traceevent build dir with OUTPUT variable set
      perf tools: Fix parsing of 64 bit raw config value for 32 bit
      tools lib traceevent: Fix cast from pointer to integer for 32 bit
      perf list: Update documentation about raw event setup
      perf list: Document precise event sampling for AMD IBS

 tools/lib/traceevent/event-parse.c                 |    3 +-
 tools/perf/Documentation/Makefile                  |    6 +-
 tools/perf/Documentation/perf-list.txt             |   48 +++--
 tools/perf/Makefile                                |    8 +-
 tools/perf/builtin-script.c                        |    5 +-
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |   94 ++++++++++
 .../perf/scripts/python/event_analyzing_sample.py  |  193 ++++++++++++++++++++
 tools/perf/util/parse-events.c                     |    6 +-
 tools/perf/util/parse-events.h                     |    6 +-
 tools/perf/util/parse-events.l                     |    4 +-
 tools/perf/util/parse-events.y                     |   10 +-
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   85 ++++++++-
 tools/perf/util/trace-event-scripting.c            |    2 +-
 tools/perf/util/trace-event.h                      |    5 +-
 15 files changed, 441 insertions(+), 45 deletions(-)
 create mode 100755 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
 create mode 100644 tools/perf/scripts/python/event_analyzing_sample.py
