Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab1C3JcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:23 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:41963 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab1C3JcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:21 -0400
X-AuditID: b753bd60-a454dba0000001d0-17-4d92f8a23f54
X-AuditID: b753bd60-a454dba0000001d0-17-4d92f8a23f54
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  00/12] Perf probe bugfixes and debuginfo object
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp
Date: Wed, 30 Mar 2011 18:25:33 +0900
Message-ID: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a series of bugfixes, cleanups and updates
for perf probe.

This series fixes several bugs and cleanup code.
The biggest cleanup is separating dwarf related
code into dwarf-aux.{c,h} and add API documents.
This also introduce debuginfo object which allows
other object to include debuginfo pointer without
 #ifdefs.

Thank you,

---

Masami Hiramatsu (12):
      perf: Export debuginfo object without dwarf support
      perf probe: Introduce debuginfo to encapsulate dwarf information
      perf probe: Warn when more than two lines are given
      [CLEANUP]perf-probe: Move dwarf library routines to dwarf-aux.{c,h}
      [CLEANUP]perf probe: Remove redundant dwarf functions
      [CLEANUP]perf probe: Move strtailcmp to string.c
      [CLEANUP]perf probe: Rename DIE_FIND_CB_FOUND to DIE_FIND_CB_END
      [BUGFIX]perf probe: Fix listing incorrect line number with inline function
      [BUGFIX]perf probe: Fix to find recursively inlined function
      [BUGFIX]perf probe: Fix multiple --vars options behavior
      [BUGFIX]perf probe: Fix to remove redundant close
      [BUGFIX]perf probe: Fix to ensure function declared file


 tools/perf/Makefile            |    2 
 tools/perf/builtin-probe.c     |   11 -
 tools/perf/util/dwarf-aux.c    |  663 ++++++++++++++++++++++++++++++++
 tools/perf/util/dwarf-aux.h    |  100 +++++
 tools/perf/util/probe-event.c  |   73 ++-
 tools/perf/util/probe-finder.c |  839 ++++++++--------------------------------
 tools/perf/util/probe-finder.h |   95 ++++-
 tools/perf/util/string.c       |   19 +
 tools/perf/util/util.h         |    1 
 9 files changed, 1090 insertions(+), 713 deletions(-)
 create mode 100644 tools/perf/util/dwarf-aux.c
 create mode 100644 tools/perf/util/dwarf-aux.h

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

