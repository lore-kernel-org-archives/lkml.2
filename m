Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2DYQZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab2DYQZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:25:22 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, eranian@google.com, robert.richter@amd.com
Subject: [PATCHv2 0/6] perf, tool: event parsing enhancements/fixes
Date: Wed, 25 Apr 2012 18:24:56 +0200
Message-Id: <1335371102-11358-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
adding some enhancements/fixies for perf event parsing.

v2 changes:
   - rebased to current tip tree
   - 2/6 - ommitting pmu tests in case there's no pmu sysfs record
   - 6/6 - default the pmu event name to raw 0x<perf_event_attr::config>

Attached patches:
  1/6 perf, tool: Split term type into value type and term type
  2/6 perf, tool: Move parse event automated tests to separated object
  3/6 perf, tool: Add support for displaying event parser debug info
  4/6 perf, tool: Use allocated list for each parsed event
  5/6 perf, tool: Separate 'mem:' event scanner bits
  6/6 perf, tool: Add hardcoded name term for pmu events

thanks,
jirka
---
 tools/perf/Makefile                 |   13 +-
 tools/perf/builtin-test.c           |  552 +------------------------------
 tools/perf/util/parse-events-test.c |  625 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |  114 +++++--
 tools/perf/util/parse-events.h      |   42 ++-
 tools/perf/util/parse-events.l      |   26 ++-
 tools/perf/util/parse-events.y      |   93 ++++--
 tools/perf/util/pmu.c               |   74 +++--
 8 files changed, 883 insertions(+), 656 deletions(-)
