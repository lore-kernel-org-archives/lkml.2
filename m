Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab1LIRax (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:30:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1LIRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:30:51 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] perf tool: Refactoring IO mmap/data files code
Date: Fri,  9 Dec 2011 18:30:34 +0100
Message-Id: <1323451838-23081-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
centralizing event mmaps and output file functionality.

Adding perf_mmap object to encapsulate  event's memory maps,
and perf_data object to handle intput/output data file processing.

attached patches:
 1/4 perf, tool: Centralize the memory maps handling
 2/4 perf, tool: Factor evlist code to use global unmap function
 3/4 perf, tool: Introducing perf_mmap object
 4/4 perf, tool: Introducing perf_data object

wbr,
jirka
---
 tools/perf/Makefile               |    5 +
 tools/perf/builtin-annotate.c     |    2 +-
 tools/perf/builtin-buildid-list.c |    4 +-
 tools/perf/builtin-diff.c         |    6 +-
 tools/perf/builtin-evlist.c       |    3 +-
 tools/perf/builtin-inject.c       |    3 +-
 tools/perf/builtin-kmem.c         |    3 +-
 tools/perf/builtin-lock.c         |    3 +-
 tools/perf/builtin-record.c       |  165 ++++++++----------------------
 tools/perf/builtin-report.c       |    2 +-
 tools/perf/builtin-sched.c        |    6 +-
 tools/perf/builtin-script.c       |    3 +-
 tools/perf/builtin-timechart.c    |    5 +-
 tools/perf/builtin-top.c          |    8 +-
 tools/perf/perf.h                 |   26 -----
 tools/perf/util/data.c            |  201 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/data.h            |   64 ++++++++++++
 tools/perf/util/evlist.c          |  131 +++++-------------------
 tools/perf/util/evlist.h          |    1 +
 tools/perf/util/header.c          |   28 +++---
 tools/perf/util/header.h          |    4 +-
 tools/perf/util/mmap.c            |  140 ++++++++++++++++++++++++++
 tools/perf/util/mmap.h            |   49 +++++++++
 tools/perf/util/session.c         |  111 +++++++-------------
 tools/perf/util/session.h         |   21 +++-
 tools/perf/util/setup.py          |    2 +-
 26 files changed, 633 insertions(+), 363 deletions(-)
