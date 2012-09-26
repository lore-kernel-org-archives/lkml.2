Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2IZH4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 03:56:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55720 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2IZH4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 03:56:05 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-fa-5062b5119303
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 00/16] perf report: Add suppport for event group view (v2)
Date: Wed, 26 Sep 2012 16:47:27 +0900
Message-Id: <1348645663-25303-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my second attempt to support event group on perf report.
For basic idea and usage example, please see my original post [1].

The main difference than v1 is adding HEADER_GROUP_DESC feature and
use it for regenerating group relationship on perf report.  It will
save actual (i.e. contains non-leader member) group information to
perf header.

Patch 1 is a bug fix which can be applied indenpedently.

Patch 2-4 are cleanups to facilitate later changes and came from my
cumulative report series [2].

You can also access it via my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/group-v2

Any comments are welcome, thanks,
Namhyung

v1 -> v2:
 * save group relation to header (Jiri)
 * rebase on top of current acme/perf/core


[1] https://lkml.org/lkml/2012/7/24/81
[2] https://lkml.org/lkml/2012/9/13/81

Namhyung Kim (16):
  perf hists: Add missing period_* fields when collapsing a hist entry
  perf hists: Introduce struct he_stat
  perf hists: Move he->stat.nr_events initialization to a template
  perf hists: Add more helpers for hist entry stat
  perf tools: Keep group information
  perf evlist: Add perf_evlist__recalc_nr_groups
  perf header: Add HEADER_GROUP_DESC feature
  perf hists: Collapse group hist_entries to a leader
  perf hists: Maintain total periods of group members in the leader
  perf report: Make another loop for output resorting
  perf ui/hist: Add support for event group view
  perf ui/browser: Add support for event group view
  perf ui/gtk: Add support for event group view
  perf report: Bypass non-leader events when event group is enabled
  perf report: Show group description when event group is enabled
  perf report: Add --group option

 tools/perf/builtin-record.c    |   6 ++
 tools/perf/builtin-report.c    |  29 +++++++
 tools/perf/ui/browsers/hists.c | 107 ++++++++++++++++++++---
 tools/perf/ui/gtk/browser.c    |  70 ++++++++++++---
 tools/perf/ui/hist.c           | 104 +++++++++++++++++------
 tools/perf/ui/stdio/hist.c     |   4 +-
 tools/perf/util/evlist.c       |  26 +++++-
 tools/perf/util/evlist.h       |   2 +
 tools/perf/util/evsel.c        |  25 ++++++
 tools/perf/util/evsel.h        |  23 +++++
 tools/perf/util/header.c       | 149 ++++++++++++++++++++++++++++++++
 tools/perf/util/header.h       |   2 +
 tools/perf/util/hist.c         | 188 +++++++++++++++++++++++++++++++++++------
 tools/perf/util/hist.h         |   2 +
 tools/perf/util/parse-events.c |   1 +
 tools/perf/util/parse-events.h |   1 +
 tools/perf/util/parse-events.y |   4 +
 tools/perf/util/sort.h         |  17 ++--
 tools/perf/util/symbol.c       |   4 +
 tools/perf/util/symbol.h       |   3 +-
 20 files changed, 683 insertions(+), 84 deletions(-)

-- 
1.7.11.4

