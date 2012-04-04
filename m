Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2DDVQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2DDVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:37 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org
Subject: [RFCv2 0/8] perf tool: Add new event group management
Date: Wed,  4 Apr 2012 23:16:08 +0200
Message-Id: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for creating event groups based on the way they
are specified on the command line. 

- added 'group=...' syntax to group events (patches 1-5).
  I think this part is quite ready.

- added 'group:1=...' syntax to specify which event to sample (leader)
  and use  PERF_SAMPLE_READ and PERF_FORMAT_GROUP to read all siblings
  on every leader's events (patches 6-8).
  Currently it is only possible to display siblings values by
  'perf report -D' PERF_SAMPLE_READ dump output containing only perf
  internal IDs displayed.. so not very usefull. But I was hoping to
  straighten up the data design/directions before I touch the gui.


Attached patches:
 1/8 perf, tool: Add support to parse event group syntax
 2/8 perf, tool: Enable grouping logic for parsed events
 3/8 perf: Add PERF_EVENT_IOC_ID ioctl to return event ID
 4/8 perf, tool: Use PERF_EVENT_IOC_ID perf ioctl to read event id
 5/8 perf, tool: Separate 'mem:' event scanner bits
 6/8 perf, tool: Add modifier support to group event syntax
 7/8 perf, tool: Add support for parsing PERF_SAMPLE_READ
 8/8 perf, tool: Enable sampling on specified event group leader

thanks for comments,
jirka
---
 include/linux/perf_event.h          |    1 +
 kernel/events/core.c                |    9 +++
 tools/perf/builtin-record.c         |   13 ++---
 tools/perf/builtin-stat.c           |   13 ++---
 tools/perf/builtin-test.c           |   12 ++--
 tools/perf/builtin-top.c            |   12 +---
 tools/perf/util/event.h             |   21 ++++++-
 tools/perf/util/evlist.c            |  120 +++++++++++++++++++++++++++--------
 tools/perf/util/evlist.h            |    8 ++-
 tools/perf/util/evsel.c             |   94 +++++++++++++++++++++-------
 tools/perf/util/evsel.h             |   16 ++---
 tools/perf/util/parse-events-test.c |   93 ++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c      |    6 ++
 tools/perf/util/parse-events.h      |    1 +
 tools/perf/util/parse-events.l      |   39 +++++++++++-
 tools/perf/util/parse-events.y      |   66 +++++++++++++++++---
 tools/perf/util/python.c            |   10 ++-
 tools/perf/util/session.c           |   42 ++++++++++++
 tools/perf/util/session.h           |    5 +-
 19 files changed, 476 insertions(+), 105 deletions(-)
