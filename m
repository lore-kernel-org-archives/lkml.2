Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab2JKEZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:25:47 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2JKEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:42 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/9] perf: consolidate all the open counters loops
Date: Wed, 10 Oct 2012 22:25:26 -0600
Message-Id: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACME was a litle slow today (ACME Component Mgmt Env that is) so managed
to add perf-stat to the list and do a decent amount of testing. This
consolidates all of the open counters loops into a single common one.

David Ahern (9):
  perf python: add ui stubs file
  perf top: make use of perf_record_opts
  perf evlist: introduce open counters method
  perf top: use the new perf_evlist__open_counters method
  perf record: use the new perf_evlist__open_counters method
  perf stat: move user options to perf_record_opts
  perf evlist: add stat unique code to open_counters method
  perf stat: move to perf_evlist__open_counters
  perf evsel: remove perf_evsel__open_per_cpu

 tools/perf/builtin-record.c        |  109 +---------------
 tools/perf/builtin-stat.c          |  240 ++++++++++++++++--------------------
 tools/perf/builtin-top.c           |  142 ++++++---------------
 tools/perf/util/evlist.c           |  139 ++++++++++++++++++++-
 tools/perf/util/evlist.h           |    4 +
 tools/perf/util/evsel.c            |    6 -
 tools/perf/util/evsel.h            |    2 -
 tools/perf/util/python-ext-sources |    1 +
 tools/perf/util/top.c              |   20 +--
 tools/perf/util/top.h              |    9 +-
 10 files changed, 303 insertions(+), 369 deletions(-)

-- 
1.7.10.1

