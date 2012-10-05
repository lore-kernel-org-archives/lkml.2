Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2JEOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:45:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab2JEOpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:45:23 -0400
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
Subject: [PATCHv3 0/8] perf diff: Factor diff command
Date: Fri,  5 Oct 2012 16:44:39 +0200
Message-Id: <1349448287-18919-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
this is v3 of diff command changes proposed in here:
https://lkml.org/lkml/2012/9/6/344

Half of the previous patchset version (hists related) got already in
together with changes of Namhyung Kim. This is what remained, plus
additional small fixies from review.

 - small delta format changes (Namhyung Kim)
 - better error messages for -c option (Andi Kleen)

Thanks a lot to Andi Kleen, who tested this and provided
great feedback! I plan to address following in future:

 - bucketizing per line instead of per function
 - allow diff to specify vmlinux files per data
 - recognize/compare same functions within 2 different kernels
 - define groups of callers that have a combined cost including all
   callees, use this as the diff unit
   (http://marc.info/?l=linux-kernel&m=134919541904105&w=2)

Attached patches:
  1/8 perf diff: Add -b option for perf diff to display paired entries only
  2/8 perf diff: Add ratio computation way to compare hist entries
  3/8 perf diff: Add option to sort entries based on diff computation
  4/8 perf diff: Add weighted diff computation way to compare hist entries
  5/8 perf diff: Add -p option to display period values for hist entries
  6/8 perf diff: Add -F option to display formula for computation
  7/8 perf diff: Include samples without symbol in overall stats
  8/8 perf diff: Display empty space for non paired samples

Available also at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
  perf/diff1

wbr,
jirka

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
 tools/perf/Documentation/perf-diff.txt |  60 ++++++++++++++
 tools/perf/builtin-diff.c              | 401 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/hist.c                   | 134 ++++++++++++++++++++++++++----
 tools/perf/ui/stdio/hist.c             |   2 +-
 tools/perf/util/hist.h                 |   8 ++
 tools/perf/util/sort.h                 |  18 ++++
 6 files changed, 600 insertions(+), 23 deletions(-)
