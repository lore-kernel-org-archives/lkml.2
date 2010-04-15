Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0DOB1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 21:27:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43828 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0DOB1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 21:27:54 -0400
Date: Wed, 14 Apr 2010 22:27:43 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mhiramat@infradead.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] perf probe batch and a fix for sort_entries
Message-ID: <20100415012743.GP25649@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

	Please consider pulling from:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6 perf

	All patches already appeared on lkml,

Best Regards,

- Arnaldo

Frederic Weisbecker (1):
  perf tools: Fix accidentally preprocessed snprintf callback

Masami Hiramatsu (16):
  perf probe: Support argument name
  perf probe: Use the last field name as the argument name
  tracing/kprobes: Support basic types on dynamic events
  perf probe: Query basic types from debuginfo
  perf probe: Support basic type casting
  perf probe: Support DW_OP_call_frame_cfa in debuginfo
  perf probe: Remove die() from probe-finder code
  perf probe: Remove die() from probe-event code
  perf probe: Remove xzalloc() from util/probe-{event, finder}.c
  perf probe: Remove xstrdup()/xstrndup() from util/probe-{event, finder}.c
  perf probe: Fix to use correct debugfs path finder
  perf probe: Fix mis-estimation for shortening filename
  perf probe: Fix a bug that --line range can be overflow
  perf probe: Fix line range to show end line
  perf probe: Support DW_OP_plus_uconst in DW_AT_data_member_location
  perf probe: Show function entry line as probe-able

 Documentation/trace/kprobetrace.txt     |    4 +-
 kernel/trace/trace.h                    |   16 +-
 kernel/trace/trace_kprobe.c             |  535 +++++++++++-------
 tools/perf/Documentation/perf-probe.txt |   11 +-
 tools/perf/builtin-probe.c              |   78 ++-
 tools/perf/util/hist.c                  |   28 +-
 tools/perf/util/probe-event.c           |  898 ++++++++++++++++++++++---------
 tools/perf/util/probe-event.h           |   33 +-
 tools/perf/util/probe-finder.c          |  753 ++++++++++++++++++--------
 tools/perf/util/probe-finder.h          |    1 +
 tools/perf/util/sort.c                  |   42 +-
 tools/perf/util/sort.h                  |   12 +-
 12 files changed, 1634 insertions(+), 777 deletions(-)

