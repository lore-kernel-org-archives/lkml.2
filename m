Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab2LFPLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:11:49 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50351 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2LFPLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:11:48 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] perf hists: Changes on hists__{match,link} (v3)
Date: Fri,  7 Dec 2012 00:09:36 +0900
Message-Id: <1354806581-5316-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I rebased my series on Jiri's diff displacement removal patch.  As the
displacement logic is gone, no need to resort (by period) baseline
since the output is only aligned to a newer data (i.e. "other" hists).

I also pushed the branch onto my tree at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git perf/link-v3

Please take a look and give comments.  Any comments are welcome.

Thanks,
Namhyung


Jiri Olsa (1):
  perf diff: Removing displacement output option

Namhyung Kim (4):
  perf hists: Exchange order of comparing items when collapsing hists
  perf hists: Link hist entries before inserting to an output tree
  perf diff: Use internal rb tree for compute resort
  perf test: Add a test case for hists__{match,link}

 tools/perf/Documentation/perf-diff.txt |    4 -
 tools/perf/Makefile                    |    1 +
 tools/perf/builtin-diff.c              |  104 ++-----
 tools/perf/tests/builtin-test.c        |    4 +
 tools/perf/tests/hists_link.c          |  502 ++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h               |    1 +
 tools/perf/ui/hist.c                   |   25 --
 tools/perf/util/hist.c                 |   51 +++-
 tools/perf/util/hist.h                 |    1 -
 tools/perf/util/machine.h              |    1 +
 tools/perf/util/session.c              |    2 +-
 11 files changed, 580 insertions(+), 116 deletions(-)
 create mode 100644 tools/perf/tests/hists_link.c

-- 
1.7.9.2

