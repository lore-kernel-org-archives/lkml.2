Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab2GSVyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 17:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab2GSVyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 17:54:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com
Subject: [PATCHv4 0/4] perf tool: Add new event group management
Date: Thu, 19 Jul 2012 23:53:53 +0200
Message-Id: <1342734837-1825-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
adding support for creating event groups based on the way they
are specified on the command line.

This patchset adds the '{}' style grammar to express event group,
allowing so far only the 'event modifier' as group modifier.

v4 changes:
  - group modifier updates events modifiers (not overwrite as in v3)

Attached patches:
  perf, tool: Add support to parse event group syntax
  perf, tool: Add support to update event modifier
  perf, tool: Enable grouping logic for parsed events
  perf, test: Add automated tests for event group parsing

wbr,
jirka
---
 tools/perf/builtin-record.c         |   13 ++-
 tools/perf/builtin-stat.c           |   13 ++-
 tools/perf/builtin-test.c           |    8 +-
 tools/perf/builtin-top.c            |   12 +--
 tools/perf/util/evlist.c            |   20 ++---
 tools/perf/util/evlist.h            |    3 +-
 tools/perf/util/evsel.c             |   51 +++++++----
 tools/perf/util/evsel.h             |   13 +--
 tools/perf/util/parse-events-test.c |  303 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c      |  104 +++++++++++++++++++---
 tools/perf/util/parse-events.h      |    5 +-
 tools/perf/util/parse-events.l      |    2 +
 tools/perf/util/parse-events.y      |   93 +++++++++++++++++---
 tools/perf/util/python.c            |    7 +-
 14 files changed, 552 insertions(+), 95 deletions(-)
