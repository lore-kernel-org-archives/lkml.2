Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab2J2Qb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:31:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:63910 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759542Ab2J2Qb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:31:57 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/9 v2] perf: consolidate all the open counters loops
Date: Mon, 29 Oct 2012 10:31:40 -0600
Message-Id: <1351528309-87705-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set consolidates all of the open counters loops into a
single common one.

Rebased to latest perf/core. Added more hooks to ui stubs file.

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

 tools/perf/builtin-record.c        |  116 +----------------
 tools/perf/builtin-stat.c          |  246 ++++++++++++++++--------------------
 tools/perf/builtin-top.c           |  146 ++++++---------------
 tools/perf/util/evlist.c           |  143 ++++++++++++++++++++-
 tools/perf/util/evlist.h           |    4 +
 tools/perf/util/evsel.c            |    6 -
 tools/perf/util/evsel.h            |    2 -
 tools/perf/util/python-ext-sources |    1 +
 tools/perf/util/python_stubs.c     |   54 ++++++++
 tools/perf/util/top.c              |   20 +--
 tools/perf/util/top.h              |    9 +-
 11 files changed, 366 insertions(+), 381 deletions(-)
 create mode 100644 tools/perf/util/python_stubs.c

-- 
1.7.10.1

