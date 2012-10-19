Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab2JSOzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:55:25 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33909 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab2JSOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:55:24 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, Stephane Eranian <eranian@gmail.com>
Subject: [PATCH 0/2] perf: enforce exclusive PMU access for SNB INST_RETIRED:PREC_DIST
Date: Fri, 19 Oct 2012 16:52:04 +0200
Message-Id: <1350658326-14715-1-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@gmail.com>

The following patch set enforces exclusive PMU access for
Intel SandyBridge INST_REITRED:PREC_DIST event when used
with PEBS as described in the SDM Vol 3b. Without this,
the sample distribution may not be correct.

The kernel now rejects PEBS + INST_RETIRED:PREC_DIST
on SNB if attr->exclusive is not set. One reason to
do it this way is to make sure users understands the
restriction. If the kernel were to force exclusive
on the fly, users would have cases where they would
get no samples and no error messages to understand
why.

The first patch extends perf to allow users to request
exclusive PMU access by introducing a new modifier: x.
For instance:
  $ perf record -e r01c0:ppx .....
or
  $ perf record -e cpu/event=0xc0,umask=0x1/ppx ....

Signed-off-by: Stephane Eranian <eranian@google.com>
---

Stephane Eranian (2):
  perf tools: add event modifier to request exclusive PMU access
  perf: enforce SNB exclusive access for INST_RETIRED:PREC_DIST

 arch/x86/kernel/cpu/perf_event.h       |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |   30 +++++++++++++++++++++++++-----
 tools/perf/util/parse-events.c         |    7 +++++++
 tools/perf/util/parse-events.l         |    2 +-
 4 files changed, 34 insertions(+), 7 deletions(-)

-- 
1.7.9.5

