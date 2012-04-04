Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2DDUV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:21:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2DDUV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:21:57 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] perf tool: event parsing enhancements/fixes
Date: Wed,  4 Apr 2012 22:21:30 +0200
Message-Id: <1333570898-10505-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
adding some enhancements/fixies for perf event parsing.

- patch 1 is simple fix

- patches 2, 3, 4 and 5 are event config terms enhancements

- patches 6, 7 and 8 are maintanance patches either helping
  with developement (6, 7) or making the code more clear (8).

Attached patches:
 1/8 perf, tool: Fix NULL deref in hists browsing code
 2/8 perf, tool: Split term type into value type and term type
 3/8 perf, tool: Add list type for event term parsing
 4/8 perf, tool: Add hardcoded name term for pmu events
 5/8 perf, tool: Add pmu event parse support for branch_sample_type values
 6/8 perf, tool: Move parse event automated tests to separated object
 7/8 perf, tool: Add support for displaying event parser debug info
 8/8 perf, tool: Use allocated list for each parsed event

thanks,
jirka
---
 tools/perf/Makefile                 |   13 +-
 tools/perf/builtin-record.c         |   31 +--
 tools/perf/builtin-test.c           |  522 +-------------------------------
 tools/perf/util/parse-events-test.c |  588 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |  240 +++++++++++++--
 tools/perf/util/parse-events.h      |   59 +++-
 tools/perf/util/parse-events.l      |    2 +
 tools/perf/util/parse-events.y      |  147 ++++++++--
 tools/perf/util/pmu.c               |   85 ++++--
 tools/perf/util/pmu.h               |    2 +
 tools/perf/util/ui/browsers/hists.c |    3 +
 11 files changed, 1037 insertions(+), 655 deletions(-)
