Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab2LJIaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:30:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2LJIaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:30:00 -0500
X-AuditID: 9c930197-b7bd3ae000003f1c-0d-50c59d8574fa
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        namhyung.kim@lge.com
Subject: [PATCH 0/4] perf hists: Changes on hists__{match,link} (v4)
Date: Mon, 10 Dec 2012 17:29:53 +0900
Message-Id: <1355128197-18193-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new version of hists link patchset.

In this version, I've addressed Jiri's comment and added his acked-by's.
Also added a comment on hist_entry__cmp() in order to clarify the reason
of the change of the argument order exchange as Arnaldo suggested.
Hoping that I didn't miss any of remaining issues on this.

I also pushed it on 'perf/link-v4' branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

Please have a look, thanks.
Namhyung


Namhyung Kim (4):
  perf hists: Exchange order of comparing items when collapsing hists
  perf hists: Link hist entries before inserting to an output tree
  perf diff: Use internal rb tree for compute resort
  perf test: Add a test case for hists__{match,link}

 tools/perf/Makefile             |   1 +
 tools/perf/builtin-diff.c       |  92 +++-----
 tools/perf/tests/builtin-test.c |   4 +
 tools/perf/tests/hists_link.c   | 502 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 tools/perf/util/hist.c          |  59 +++--
 tools/perf/util/hist.h          |   1 +
 tools/perf/util/machine.h       |   1 +
 tools/perf/util/session.c       |   2 +-
 9 files changed, 592 insertions(+), 71 deletions(-)
 create mode 100644 tools/perf/tests/hists_link.c

-- 
1.7.11.7

