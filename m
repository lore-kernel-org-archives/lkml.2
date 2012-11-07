Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2KGH1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:27:19 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50186 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2KGH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:27:18 -0500
X-AuditID: 9c930179-b7c8bae000003559-20-509a0d532746
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: [RFC/PATCH 0/6] perf tools: Additional works for memory access sampling
Date: Wed,  7 Nov 2012 16:27:08 +0900
Message-Id: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During playing with the Stephane's memory access sampling series [1],
I needed to have these patches to make perf mem work properly.

It still gets a segfult when analyzing system wide sample data, and
needs more work on dealing with kernel's percpu symbols and rodata
symbols in user app, it worked well for my toy application at least
sometimes. ;-) I'll continue to chasing it down but before doing it
I'd like to share what I have now.

Thanks,
Namhyung

[1] https://lkml.org/lkml/2012/11/5/485


Namhyung Kim (6):
  perf tools: Synthesize data mmap events for threads
  perf tools: Set kernel data mapping length
  perf tools: Fix detection of stack area
  perf tools: Ignore ABS symbols when loading data maps
  perf tools: Fix output of symbol_daddr offset
  perf tools: Free {branch,mem}_info when freeing hist_entry

 tools/perf/util/event.c      | 78 ++++++++++++++++++++------------------------
 tools/perf/util/hist.c       |  2 ++
 tools/perf/util/machine.c    | 22 ++++++++-----
 tools/perf/util/map.c        |  2 +-
 tools/perf/util/sort.c       |  2 +-
 tools/perf/util/symbol-elf.c |  3 ++
 6 files changed, 55 insertions(+), 54 deletions(-)

-- 
1.7.11.7

