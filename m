Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2L0JMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:12:30 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50609 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab2L0JM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:12:29 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-0b-50dc10fbee02
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCHSET 00/10] perf tools: Cleanups and bug fixes on sort keys
Date: Thu, 27 Dec 2012 18:11:37 +0900
Message-Id: <1356599507-14226-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's a bug report from Stefan Beller that gets segfault on using
some sort keys.  In addition to it, I had some TODO items related to
it, hence this patchset. :)

This is mostly simple few liners and more complex ones might come later.

Stephane, it'd be great if you check I'm not messed up something on
the branch stack side (or other area too).  Although I've tested basic
functionality there might be something that I missed.

You can also get this from following tree:

git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git perf/sort-v1

Thanks,
Namhyung


Cc: Stephane Eranian <eranian@google.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>

Namhyung Kim (10):
  perf sort: Move misplaced sort entry functions
  perf sort: Get rid of unnecessary __maybe_unused
  perf sort: Fix --sort pid output
  perf sort: Align cpu column to right
  perf sort: Calculate parent column width too
  perf sort: Drop ip_[lr] arguments from _sort__sym_cmp()
  perf sort: Check return value of strdup()
  perf sort: Clean up sort__first_dimension setting
  perf sort: Separate out branch stack specific sort keys
  perf report: Update documentation for sort keys

 tools/perf/Documentation/perf-report.txt |  38 ++++-
 tools/perf/builtin-report.c              |   4 +-
 tools/perf/util/hist.c                   |   3 +
 tools/perf/util/sort.c                   | 230 ++++++++++++++++---------------
 tools/perf/util/sort.h                   |   8 +-
 5 files changed, 166 insertions(+), 117 deletions(-)

-- 
1.7.11.7

