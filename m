Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab2F2JJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:09:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab2F2JJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:09:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: [PATCHv3 0/3] perf tool: Add new event group management
Date: Fri, 29 Jun 2012 11:08:24 +0200
Message-Id: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for creating event groups based on the way they
are specified on the command line.

This patchset adds the '{}' style grammar to express event group,
allowing so far only the 'event modifier' as group modifier.

The sample/leader modifier changes are ready, but I'm getting
some weird numbers in tests, so I'll send it later. Meanwhile,
it'd be nice to have at least this patchset in.. ;)


Attached patches:
  1/3 perf, tool: Add support to parse event group syntax
  2/3 perf, tool: Enable grouping logic for parsed events
  3/3 perf, test: Add automated tests for event group parsing

wbr,
jirka
---
 tools/perf/builtin-record.c         |   13 +--
 tools/perf/builtin-stat.c           |   13 +--
 tools/perf/builtin-test.c           |    8 +-
 tools/perf/builtin-top.c            |   12 +--
 tools/perf/util/evlist.c            |   20 ++---
 tools/perf/util/evlist.h            |    3 +-
 tools/perf/util/evsel.c             |   51 ++++++++----
 tools/perf/util/evsel.h             |   11 +--
 tools/perf/util/parse-events-test.c |  152 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   32 +++++++-
 tools/perf/util/parse-events.h      |    5 +-
 tools/perf/util/parse-events.l      |    2 +
 tools/perf/util/parse-events.y      |   93 ++++++++++++++++++---
 tools/perf/util/python.c            |    7 +-
 14 files changed, 341 insertions(+), 81 deletions(-)
