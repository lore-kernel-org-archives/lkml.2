Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab2EUHOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab2EUHNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:13:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCHv3 0/5] perf, tool: event parsing enhancements/fixes
Date: Mon, 21 May 2012 09:12:48 +0200
Message-Id: <1337584373-2741-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
adding some enhancements/fixies for perf event parsing.

v3 changes
   - rebased to current
     git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux perf/core
   - patch 1/6 from v2 got already commited

v2 changes:
   - rebased to current tip tree
   - 2/6 - ommitting pmu tests in case there's no pmu sysfs record
   - 6/6 - default the pmu event name to raw 0x<perf_event_attr::config>

Attached patches:
  1/5 perf, tool: Move parse event automated tests to separated object
  2/5 perf, tool: Add support for displaying event parser debug info
  3/5 perf, tool: Use allocated list for each parsed event
  4/5 perf, tool: Separate 'mem:' event scanner bits
  5/5 perf, tool: Add hardcoded name term for pmu events


thanks,
jirka

CC: "Yan, Zheng" <zheng.z.yan@intel.com>
---
 tools/perf/Makefile                 |   13 +-
 tools/perf/builtin-test.c           |  552 +------------------------------
 tools/perf/util/parse-events-test.c |  625 +++++++++++++++++++++++++++++++++++
 tools/perf/util/parse-events.c      |   69 +++-
 tools/perf/util/parse-events.h      |   20 +-
 tools/perf/util/parse-events.l      |   26 ++-
 tools/perf/util/parse-events.y      |   77 ++++-
 tools/perf/util/pmu.c               |    4 +-
 8 files changed, 786 insertions(+), 600 deletions(-)
