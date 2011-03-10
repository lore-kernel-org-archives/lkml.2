Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1CJFWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:22:54 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:45745 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab1CJFWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 00:22:52 -0500
X-IronPort-AV: E=Sophos;i="4.62,294,1297036800"; 
   d="scan'208";a="276249608"
From: David Ahern <daahern@cisco.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de,
        David Ahern <daahern@cisco.com>
Subject: [PATCH 0/6 v4] perf script: add support for dumping events other than trace
Date: Wed,  9 Mar 2011 22:23:22 -0700
Message-Id: <1299734608-5223-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 -> v4:
- moved code removal to separate patch
- added check that callchain exists before trying to use it
- cleaned up whitespace errors so acme does not have to

v2 -> v3:
- removed show-unresolved option
- setup different output defaults based on event type
- moved printing of comm, pid/tid, time and event name from print_event to
  builtin-script and renamed print_event to print_trace_event
- removed unneeded cursor depth check
- updated to latest perf-core to get Arnaldo's recent makeovers
- created smaller, focused patches 

v1 -> v2:
- fixed process_event handler in trace-event-perl
- removed unneeded call to callchain_register_param
- corrected walking of callchains in perf_session__print_symbols
- complete rewrite for handling non-tracepoint events


David Ahern (6):
  perf script: change process_event prototype
  perf: remove print_graph_cpu and print_graph_proc from
    trace-event-parse
  perf script: move printing of 'common' data from print_event and
    rename
  perf script: support custom field selection for output
  perf script: add support for dumping symbols
  perf script: add support for H/W and S/W events

 tools/perf/Documentation/perf-script.txt           |   22 ++
 tools/perf/builtin-script.c                        |  300 ++++++++++++++++++--
 tools/perf/util/parse-events.c                     |   22 ++
 tools/perf/util/parse-events.h                     |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |   11 +-
 .../util/scripting-engines/trace-event-python.c    |   11 +-
 tools/perf/util/session.c                          |   61 ++++
 tools/perf/util/session.h                          |    4 +
 tools/perf/util/trace-event-parse.c                |  110 +-------
 tools/perf/util/trace-event-scripting.c            |    9 +-
 tools/perf/util/trace-event.h                      |   10 +-
 11 files changed, 423 insertions(+), 138 deletions(-)

-- 
1.7.4

