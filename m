Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2CTSQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab2CTSQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:16:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/3] perf tool: Add new event group management
Date: Tue, 20 Mar 2012 19:15:38 +0100
Message-Id: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for creating event groups based on the way they
are specified on the command line. Also attaching several fixies
to current code.

attached patches:
 1/3 perf, tool: Fix various casting issues for 32 bits
 2/3 perf, tool: Fix modifier to be applied on correct events
 3/3 perf, tool: Add new event group management

I added automated tests and run some record and stats tests
based on the examples (attached in the 3/3 changelog), and
so far so good..

thanks for comments,
jirka
---
 tools/perf/Makefile                  |    2 +
 tools/perf/builtin-record.c          |    8 +-
 tools/perf/builtin-stat.c            |   10 +-
 tools/perf/builtin-test.c            |  126 +++++++-
 tools/perf/builtin-top.c             |    8 +-
 tools/perf/perf.h                    |    3 +-
 tools/perf/util/evlist.c             |    4 +-
 tools/perf/util/evlist.h             |    3 +-
 tools/perf/util/evsel.c              |   32 ++-
 tools/perf/util/evsel.h              |    9 +-
 tools/perf/util/group.c              |   22 ++
 tools/perf/util/group.h              |   32 ++
 tools/perf/util/header.c             |    2 +-
 tools/perf/util/parse-events-bison.c |  675 +++++++++++++++++++---------------
 tools/perf/util/parse-events-bison.h |   15 +-
 tools/perf/util/parse-events.c       |   47 ++-
 tools/perf/util/parse-events.h       |   10 +-
 tools/perf/util/parse-events.y       |   40 ++-
 tools/perf/util/python.c             |    4 +
 tools/perf/util/top.h                |    2 +-
 20 files changed, 687 insertions(+), 367 deletions(-)
