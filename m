Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2JWHol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:44:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50142 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab2JWHoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:44:39 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-3e-50864ae5e0cd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 00/12] perf report: Add support for event group view (v4)
Date: Tue, 23 Oct 2012 16:43:54 +0900
Message-Id: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my v4 of event group view support patchset.
For basic idea and usage example, please see my original post [1].

This is mostly for rebasing on acme/perf/core, and report.group config
option is added for those who wants to enable it by default.

You can get this series via my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/group-v4

Any comments are welcome, thanks,
Namhyung


v3 -> v4:
 * patch 1-9 in previous post are merged.
 * add Jiri's Acked-by
 * add report.group config option

v2 -> v3:
 * drop patch 1 since it's merged into acme/perf/core
 * cherry-pick Jiri's hpp changes
 * add missing bswap_32 on reading nr_groups (Jiri)
 * remove perf_evlist__recalc_nr_groups() in favor of list_is_last (Jiri)

v1 -> v2:
 * save group relation to header (Jiri)

[1] https://lkml.org/lkml/2012/7/24/81

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>

Namhyung Kim (12):
  perf tools: Keep group information
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
  perf report: Add report.group config option

 tools/perf/builtin-record.c    |   3 +
 tools/perf/builtin-report.c    |  42 ++++++++++++
 tools/perf/ui/browsers/hists.c |  99 +++++++++++++++++++++++++--
 tools/perf/ui/gtk/browser.c    |  72 +++++++++++++++----
 tools/perf/ui/hist.c           |  71 +++++++++++++++++--
 tools/perf/ui/stdio/hist.c     |   2 +
 tools/perf/util/evlist.c       |  10 ++-
 tools/perf/util/evlist.h       |   1 +
 tools/perf/util/evsel.c        |  25 +++++++
 tools/perf/util/evsel.h        |  23 +++++++
 tools/perf/util/header.c       | 152 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h       |   2 +
 tools/perf/util/hist.c         | 133 +++++++++++++++++++++++++++++++++---
 tools/perf/util/hist.h         |   1 +
 tools/perf/util/parse-events.c |   1 +
 tools/perf/util/parse-events.h |   1 +
 tools/perf/util/parse-events.y |  10 +++
 tools/perf/util/sort.h         |   1 +
 tools/perf/util/symbol.c       |   4 ++
 tools/perf/util/symbol.h       |   3 +-
 20 files changed, 618 insertions(+), 38 deletions(-)

-- 
1.7.11.7

