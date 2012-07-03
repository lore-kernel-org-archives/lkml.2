Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2GCWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 18:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2GCWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 18:01:07 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFCv2 0/10] perf, tool: Allow to use hw events in PMU syntax
Date: Wed,  4 Jul 2012 00:00:38 +0200
Message-Id: <1341352848-11833-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
here's the change to make following syntax available:
  perf stat -e cpu/event=instructions/u ls

this is identical to:
  perf stat -e instructions:u ls

v2 changes:
  - making the hw events translations available under the 'events',
    the userspace trnaslation is then done by existing term aliasing
    code with some little tweeks ;)
  - patches 1-3 are independent fixies

Attached patches:
  01/10 perf, tool: Add empty rule for new line in event syntax parsing
  02/10 perf, tool: Fix pmu object initialization
  03/10 perf, tool: Properly free format data
  04/10 perf, x86: Making hardware events translations available in sysfs
  05/10 perf, tool: Split out PE_VALUE_SYM parsing token to SW and HW tokens
  06/10 perf, tool: Split event symbols arrays to hw and sw parts
  07/10 perf, tool: Add support to specify hw event as pmu event term
  08/10 perf, tool: Add sysfs read file interface
  09/10 perf, test: Use ARRAY_SIZE in parse events tests
  10/10 perf, test: Add automated tests for pmu sysfs translated events

jirka
---
 arch/x86/kernel/cpu/perf_event.c    |   44 ++++++++++++++
 tools/perf/util/parse-events-test.c |  158 ++++++++++++++++++++++++++++++++++++++++++++------
 tools/perf/util/parse-events.c      |  203 +++++++++++++++++++++++++++++++++++++++++++++++------------------
 tools/perf/util/parse-events.h      |    2 +
 tools/perf/util/parse-events.l      |    3 +-
 tools/perf/util/parse-events.y      |   24 ++++++--
 tools/perf/util/pmu.c               |   60 ++++++++++++-------
 tools/perf/util/sysfs.c             |   19 ++++++
 tools/perf/util/sysfs.h             |    1 +
 9 files changed, 413 insertions(+), 101 deletions(-)
