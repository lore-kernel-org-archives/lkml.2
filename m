Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab1CISbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:31:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57674 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab1CISbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:31:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [GIT PULL 00/10] perf/core fixes and improvements
Date: Wed,  9 Mar 2011 15:31:21 -0300
Message-Id: <1299695491-15786-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

        Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf/core

Regards,

- Arnaldo

Arnaldo Carvalho de Melo (3):
  perf session: Simplify evlist creation from perf.data header
  perf evsel: Assume rest of perf_header_attr functions
  perf header: Stop using 'self'

David Ahern (5):
  perf script: Change process_event prototype
  perf script: Move printing of 'common' data from print_event and rename
  perf script: Support custom field selection for output
  perf script: Add support for dumping symbols
  perf script: Add support for H/W and S/W events

Jiri Olsa (2):
  perf top: Fix events overflow in top command
  perf top: Don't let events to eat up whole header line

 tools/perf/Documentation/perf-script.txt           |   22 +
 tools/perf/builtin-record.c                        |   94 ++---
 tools/perf/builtin-report.c                        |    4 +-
 tools/perf/builtin-script.c                        |  295 +++++++++++++--
 tools/perf/util/evlist.c                           |   26 +-
 tools/perf/util/evlist.h                           |    4 +-
 tools/perf/util/evsel.c                            |   21 +-
 tools/perf/util/evsel.h                            |    9 +-
 tools/perf/util/header.c                           |  422 +++++++++-----------
 tools/perf/util/header.h                           |   48 +--
 tools/perf/util/parse-events.c                     |   22 +
 tools/perf/util/parse-events.h                     |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   11 +-
 tools/perf/util/session.c                          |  124 +++---
 tools/perf/util/session.h                          |    4 +
 tools/perf/util/top.c                              |   48 ++-
 tools/perf/util/trace-event-parse.c                |  106 +-----
 tools/perf/util/trace-event-scripting.c            |    9 +-
 tools/perf/util/trace-event.h                      |   10 +-
 20 files changed, 730 insertions(+), 561 deletions(-)

