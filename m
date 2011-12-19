Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1LSXXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:23:36 -0500
Received: from outmail019.snc4.facebook.com ([66.220.144.153]:34926 "EHLO
	intmgw001.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752655Ab1LSXXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:23:34 -0500
From: Arun Sharma <asharma@fb.com>
To: linux-kernel@vger.kernel.org
Cc: Arun Sharma <asharma@fb.com>
Subject: [PATCH 0/2] Sleep profiling
Date: Mon, 19 Dec 2011 15:23:23 -0800
Message-Id: <1324337005-31718-1-git-send-email-asharma@fb.com>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debugging latency, users want to know where their code
is executing on the CPU (cycle profiling) as well as where 
it's waiting sleeping or waiting for IO. The following patch set
tries to address the latter.

Normal users can use this tracepoint without root privileges
and on a system with lots of context switches, load can be
reduced by filtering out uninteresting switches.

Sample command lines:

perf record -gPe sched:sched_switch --filter "delay > 10000" -- ./test
perf report --stdio -g graph -G

Arun Sharma (2):
  tracing, sched: move the sched_switch tracepoint
  tracing, sched: Add delay info to sched_switch

 include/trace/events/sched.h      |   21 +++++++++++++++++----
 kernel/sched.c                    |    2 +-
 kernel/sched_fair.c               |    6 ++++--
 kernel/trace/trace_sched_switch.c |    2 +-
 4 files changed, 23 insertions(+), 8 deletions(-)

-- 
1.7.4

