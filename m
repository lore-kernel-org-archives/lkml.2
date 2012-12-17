Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754Ab2LQGjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 01:39:09 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56269 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab2LQGjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 01:39:08 -0500
X-AuditID: 9c930179-b7becae000000e51-59-50cebe0a6aa9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 00/14] perf report: Add support for event group view (v7)
Date: Mon, 17 Dec 2012 15:38:51 +0900
Message-Id: <1355726345-29553-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is my 7th attempt to enable the event group view for perf report.
For basic idea and usage example, please see my initial post [1].

This version is rebased on the current acme/perf/core and Jiri's multi-
diff patchset [2] and addresses comments from the previous spin.

You can get this via 'perf/group-v7' branch on my tree:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Any comments are welcome, thanks,
Namhyung


v6 -> v7:
 * hists__{match,link} changes are merged separately
 * factor out inc_group_count() from parsing group_def (Jiri)
 * add checking for group fields in evlist/evsel (Jiri)
 * check return value of during header processing (Arnaldo)
 * get rid of a temporal array in hpp functions (Arnaldo)
 * convert hpp macros to static inline functions (Jiri)

v5 -> v6:
 * set ->leader alse for leader evsel (Arnaldo)
 * use hists__{match,link} (Arnaldo)

v4 -> v5:
 * rebase onto acme/perf/core

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
[2] https://lkml.org/lkml/2012/12/13/144


Namhyung Kim (14):
  perf tools: Keep group information
  perf test: Add group test conditions
  perf header: Ensure read/write finished successfully
  perf header: Add HEADER_GROUP_DESC feature
  perf report: Make another loop for linking group hists
  perf hists: Resort hist entries using group members for output
  perf ui/hist: Add support for event group view
  perf hist browser: Add support for event group view
  perf gtk/browser: Add support for event group view
  perf gtk/browser: Trim column header string when event group enabled
  perf report: Bypass non-leader events when event group is enabled
  perf report: Show group description when event group is enabled
  perf report: Add --group option
  perf report: Add report.group config option

 tools/perf/Documentation/perf-report.txt |   3 +
 tools/perf/builtin-record.c              |   3 +
 tools/perf/builtin-report.c              |  47 +++-
 tools/perf/builtin-script.c              |  12 --
 tools/perf/tests/parse-events.c          |  28 +++
 tools/perf/ui/browsers/hists.c           | 225 ++++++++++++++++----
 tools/perf/ui/gtk/browser.c              | 131 +++++++++---
 tools/perf/ui/hist.c                     | 353 +++++++++++++++----------------
 tools/perf/ui/stdio/hist.c               |   2 +
 tools/perf/util/evlist.c                 |   7 +-
 tools/perf/util/evlist.h                 |   1 +
 tools/perf/util/evsel.c                  |  25 +++
 tools/perf/util/evsel.h                  |  16 ++
 tools/perf/util/header.c                 | 227 +++++++++++++++++---
 tools/perf/util/header.h                 |   2 +
 tools/perf/util/hist.c                   |  59 +++++-
 tools/perf/util/parse-events.c           |   1 +
 tools/perf/util/parse-events.h           |   1 +
 tools/perf/util/parse-events.y           |  10 +
 tools/perf/util/string.c                 |  18 ++
 tools/perf/util/symbol.h                 |   3 +-
 tools/perf/util/util.h                   |   1 +
 22 files changed, 885 insertions(+), 290 deletions(-)

-- 
1.7.11.7

