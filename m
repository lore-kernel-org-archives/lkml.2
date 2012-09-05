Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2IEFKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 01:10:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47884 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2IEFKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 01:10:20 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-24-5046deba9266
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] perf header: Save and reuse feature information in header (v2)
Date: Wed,  5 Sep 2012 14:02:46 +0900
Message-Id: <1346821373-31621-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a v2 of my perf header cleanup series.  The v1 can be found
here [1].

Currently the perf header information is used only at initial setup
time and discarded.  If it's saved we could reuse the information for
various purpose in the future.

The patch 1-3 are cleanups so that they can be applied independently.

I also put the series on my tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git  perf/header-v2

Any comments are welcome, thanks.
Namhyung

[1] https://lkml.org/lkml/2012/7/21/75

v1 -> v2:
 * not touch EVENT_DESC feature handling
 * split out struct perf_header_info
 * simplify multi-string handling
 * add some cleanup patches


Namhyung Kim (7):
  perf header: Use evlist->nr_entries on write_event_desc()
  perf header: Set tracepoint event name only if not set
  perf header: Swap pmu mapping numbers if needed
  perf header: Add struct perf_header_info
  perf header: Add ->process callbacks to most of features
  perf header: Use pre-processed header info when printing
  perf header: Remove unused @feat arg from ->process callback

 tools/perf/util/header.c | 528 +++++++++++++++++++++++++++++++++--------------
 tools/perf/util/header.h |  24 +++
 2 files changed, 393 insertions(+), 159 deletions(-)

-- 
1.7.11.4

