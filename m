Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2I0LKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 07:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2I0LK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 07:10:28 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCHv2 00/14] perf diff: Factor diff command
Date: Thu, 27 Sep 2012 13:09:21 +0200
Message-Id: <1348744175-11115-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this is v2 of diff command changes proposed in here:
https://lkml.org/lkml/2012/9/6/344

It's now rebased on new hists hpp* interface plus few
more additional changes.

I'm still testing/using it to come up with some proved
usability, but would be nice to have it in anyway.

v2 changes:
  - based on hpp* interface
  - patch 13/14 includes samples with no symbol in diff output
    makes diff numbers looks the same as in report
  - patch 14/14 displays empty space instead of zeros for
    non paired samples makes the output more clear

Attached patches:
  01/14 perf hists: Add struct hists pointer to struct hist_entry
  02/14 perf diff: Refactor diff displacement possition info
  03/14 perf hists: Separate overhead and baseline columns
  04/14 perf tools: Removing hists pair argument from output path
  05/14 perf diff: Add -b option for perf diff to display paired entries only
  06/14 perf tool: Add hpp interface to enable/disable hpp column
  07/14 perf diff: Add ratio computation way to compare hist entries
  08/14 perf diff: Removing the total_period argument from output code
  09/14 perf diff: Add option to sort entries based on diff computation
  10/14 perf diff: Add weighted diff computation way to compare hist entries
  11/14 perf diff: Add -p option to display period values for hist entries
  12/14 perf diff: Add -F option to display formula for computation
  13/14 perf diff: Include samples without symbol in overall stats
  14/14 perf diff: Display empty space for non paired samples

Available also at:
git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
perf/diff

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>

---
 tools/perf/Documentation/perf-diff.txt |  60 ++++++++++++
 tools/perf/builtin-diff.c              | 462 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 tools/perf/builtin-report.c            |   4 +-
 tools/perf/builtin-top.c               |   2 +-
 tools/perf/ui/browsers/hists.c         |   6 +-
 tools/perf/ui/gtk/browser.c            |   6 +-
 tools/perf/ui/hist.c                   | 256 +++++++++++++++++++++++++++++++++++++------------
 tools/perf/ui/setup.c                  |   2 +-
 tools/perf/ui/stdio/hist.c             |  45 ++++-----
 tools/perf/util/hist.c                 |   2 +
 tools/perf/util/hist.h                 |  19 ++--
 tools/perf/util/sort.h                 |  21 ++++-
 12 files changed, 759 insertions(+), 126 deletions(-)
