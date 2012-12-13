Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab2LMNL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:11:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab2LMNJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:09:35 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 00/14] perf, diff: multiple perf.data file support
Date: Thu, 13 Dec 2012 14:08:58 +0100
Message-Id: <1355404152-16523-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support to display diff for more than 2 perf.data files.

The basic idea is describe in the initial RFC in here:
https://lkml.org/lkml/2012/11/28/200

It's rebased on current Arnaldo's perf core with Namhyung's
changes.

Attached patches:
  01/14 perf diff: Use internal rb tree for hists__precompute
  02/14 perf hists: Rename hist_entry__add_pair arguments
  03/14 perf tools: Add struct perf_hpp_fmt into hpp callbacks
  04/14 perf tools: Centralize default columns init in perf_hpp__init
  05/14 perf diff: Introducing diff_data object to hold files
  06/14 perf diff: Switching the base hists to be pairs head
  07/14 perf hists: Marking dummy hists entries
  08/14 perf diff: Display data file info ahead of the diff output
  09/14 perf diff: Move diff related columns into diff command
  10/14 perf diff: Move columns into struct data__file
  11/14 perf diff: Change diff command to work over multiple data files
  12/14 perf diff: Update perf diff documentation for multiple data comparison
  13/14 perf diff: Making compute functions static
  14/14 perf diff: Add generic order option for compute sorting

thanks,
jirka


Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt |  79 +++++++++--
 tools/perf/builtin-diff.c              | 673 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 tools/perf/builtin-report.c            |   1 -
 tools/perf/ui/browsers/hists.c         |  12 +-
 tools/perf/ui/gtk/browser.c            |  12 +-
 tools/perf/ui/hist.c                   | 298 ++++++++++-------------------------------
 tools/perf/ui/setup.c                  |   1 -
 tools/perf/ui/stdio/hist.c             |   4 +-
 tools/perf/util/hist.c                 |   1 +
 tools/perf/util/hist.h                 |  24 +---
 tools/perf/util/sort.h                 |   9 +-
 11 files changed, 717 insertions(+), 397 deletions(-)
