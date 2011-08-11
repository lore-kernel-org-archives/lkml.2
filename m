Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1HKL0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:26:32 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37454 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab1HKL0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:26:31 -0400
X-AuditID: b753bd60-a3cafba0000019f4-c8-4e43bc640b47
X-AuditID: b753bd60-a3cafba0000019f4-c8-4e43bc640b47
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 0/9]perf probe bugfixes
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Thu, 11 Aug 2011 20:02:20 +0900
Message-ID: <20110811110220.19900.54963.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the updated version of bugfix series for perf probe.
I've added some bugfixes which come up with newer gcc.

Changes:
 - Update against recent changes on tip tree.
 - Add several actual outputs of the command for explaining
   the bugfix.
 - Add a line-walker bugfix for showing file-based probe-able
   lines correctly.
 - Rewrite variable searching scope bugfix into 2 patches.
 - Add 2 new debuginfo related bugfixes which I've found
   with newer gcc on fedora 15.

Thank you,

---

Masami Hiramatsu (9):
      [BUGFIX] perf probe: Filter out redundant inline-instances
      [BUGFIX] perf probe: Search concrete out-of-line instances
      [BUGFIX] perf probe: Avoid searching variables in intermediate scopes
      [BUGFIX] perf probe: Fix to search local variables in appropriate scope
      [BUGFIX] perf probe: Warn when more than one line are given
      [BUGFIX] perf probe: Fix to walk all inline instances
      [BUGFIX] perf probe: Fix to search nested inlined functions in CU
      [BUGFIX] perf probe: Fix line walker to check CU correctly
      [BUGFIX] perf-probe: Fix a memory leak for scopes array


 tools/perf/builtin-probe.c     |   14 ++
 tools/perf/util/dwarf-aux.c    |  210 ++++++++++++++++++++++++++++++++++--
 tools/perf/util/dwarf-aux.h    |   11 ++
 tools/perf/util/probe-finder.c |  231 +++++++++++++++++++++++++---------------
 tools/perf/util/probe-finder.h |    2 
 5 files changed, 360 insertions(+), 108 deletions(-)

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

