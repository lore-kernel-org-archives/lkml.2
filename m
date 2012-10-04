Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2JDMvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:51:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62392 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab2JDMvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:51:05 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/20] perf report: Add support for event group view (v3)
Date: Thu,  4 Oct 2012 21:49:34 +0900
Message-Id: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my v3 of event group view support.
For basic idea and usage example, please see my original post [1].

I rebased the series on top of selected hpp changes from Jiri's diff
patchset [2] since it contains cleanups and improves that can be used
in this series too.

You can also get it via my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/group-v3

Any comments are welcome, thanks,
Namhyung

v2 -> v3:
 * drop patch 1 since it's merged into acme/perf/core
 * cherry-pick Jiri's hpp changes
 * add missing bswap_32 on reading nr_groups (Jiri)
 * remove perf_evlist__recalc_nr_groups() in favor of list_is_last (Jiri)

v1 -> v2:
 * save group relation to header (Jiri)

[1] https://lkml.org/lkml/2012/7/24/81
[2] https://lkml.org/lkml/2012/9/27/254

Jiri Olsa (6):
  perf hists: Add struct hists pointer to struct hist_entry
  perf diff: Refactor diff displacement possition info
  perf hists: Separate overhead and baseline columns
  perf tools: Removing hists pair argument from output path
  perf tool: Add hpp interface to enable/disable hpp column
  perf diff: Removing the total_period argument from output code

Namhyung Kim (14):
  perf hists: Introduce struct he_stat
  perf hists: Move he->stat.nr_events initialization to a template
  perf hists: Add more helpers for hist entry stat
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

 tools/perf/builtin-diff.c      |   68 ++++++++++----
 tools/perf/builtin-record.c    |    3 +
 tools/perf/builtin-report.c    |   33 ++++++-
 tools/perf/builtin-top.c       |    2 +-
 tools/perf/ui/browsers/hists.c |  115 +++++++++++++++++++---
 tools/perf/ui/gtk/browser.c    |   74 ++++++++++++---
 tools/perf/ui/hist.c           |  204 +++++++++++++++++++++++++++++-----------
 tools/perf/ui/setup.c          |    2 +-
 tools/perf/ui/stdio/hist.c     |   47 ++++-----
 tools/perf/util/evlist.c       |   10 +-
 tools/perf/util/evlist.h       |    1 +
 tools/perf/util/evsel.c        |   25 +++++
 tools/perf/util/evsel.h        |   23 +++++
 tools/perf/util/header.c       |  152 ++++++++++++++++++++++++++++++
 tools/perf/util/header.h       |    2 +
 tools/perf/util/hist.c         |  195 ++++++++++++++++++++++++++++++++------
 tools/perf/util/hist.h         |   12 +--
 tools/perf/util/parse-events.c |    1 +
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/parse-events.y |   10 ++
 tools/perf/util/sort.h         |   20 ++--
 tools/perf/util/symbol.c       |    4 +
 tools/perf/util/symbol.h       |    3 +-
 23 files changed, 826 insertions(+), 181 deletions(-)

-- 
1.7.9.2

