Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab2C1P5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758361Ab2C1P5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:57:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/5] perf tool: event parsing enhancements
Date: Wed, 28 Mar 2012 17:55:48 +0200
Message-Id: <1332950153-8606-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
sending some enhancements for event parsing.

There are basically 2 features:
 - adding hardcoded term 'name' to allow specifying a name
   for the pmu event (patch 1/5)
 - implement hardcoded term 'branch_type' and allow specifying
   values like "branch_type=hv|any_ret|1" (patches 2-4/5)

Also, I was thinking of some overall event syntax documentation,
so I outlined something in patch 5/5. It's unfinished, highly
mistyped and partly stolen stuff.
What I'd expect would be some feedback about the form. Like what
it should look like.. event syntax + description of each event
type, modifiers etc.. please be gentle, it's RFC ;)


Attached patches:
 1/5 perf, tool: Add hardcoded name term for pmu events
 2/5 perf, tool: Split term type into value type and term type
 3/5 perf, tool: Add list type for event term parsing
 4/5 perf, tool: Add pmu event parse support for branch_sample_type values
 5/5 perf, tool: Add events specification doc

thanks,
jirka
---
 tools/perf/Documentation/perf-events.txt |  182 +++++++
 tools/perf/Documentation/perf-record.txt |    2 +-
 tools/perf/Documentation/perf-stat.txt   |    2 +-
 tools/perf/builtin-record.c              |   31 +-
 tools/perf/builtin-test.c                |   53 ++
 tools/perf/util/parse-events-bison.c     |  799 ++++++++++++++++--------------
 tools/perf/util/parse-events-bison.h     |   16 +-
 tools/perf/util/parse-events-flex.c      |  597 ++++++++++++-----------
 tools/perf/util/parse-events-flex.h      |    2 +-
 tools/perf/util/parse-events.c           |  194 +++++++-
 tools/perf/util/parse-events.h           |   40 ++-
 tools/perf/util/parse-events.l           |    2 +
 tools/perf/util/parse-events.y           |   79 +++-
 tools/perf/util/pmu.c                    |   85 ++--
 tools/perf/util/pmu.h                    |    2 +
 15 files changed, 1321 insertions(+), 765 deletions(-)
