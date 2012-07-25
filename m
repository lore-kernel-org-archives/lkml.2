Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab2GYT3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:29:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58459 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2GYT32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:29:28 -0400
Date: Wed, 25 Jul 2012 12:29:10 -0700
From: tip-bot for Jovi Zhang <bookjovi@gmail.com>
Message-ID: <tip-4a841d650ea435c69e60675537f158a620697290@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        bookjovi@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        bookjovi@gmail.com
In-Reply-To: <CACV3sbLF8taiCq_VYW-sgRJyupeMzg58C7ZXfMe3xZUiH_Mx6w@mail.gmail.com>
References: <CACV3sbLF8taiCq_VYW-sgRJyupeMzg58C7ZXfMe3xZUiH_Mx6w@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Make the breakpoint events sample period default to 1
Git-Commit-ID: 4a841d650ea435c69e60675537f158a620697290
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:29:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4a841d650ea435c69e60675537f158a620697290
Gitweb:     http://git.kernel.org/tip/4a841d650ea435c69e60675537f158a620697290
Author:     Jovi Zhang <bookjovi@gmail.com>
AuthorDate: Sun, 15 Jul 2012 03:03:10 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:37:46 -0300

perf tools: Make the breakpoint events sample period default to 1

There have one problem about hw_breakpoint perf event, as watched, the
events reported to userspace is not correctly, sometime one trigger
bp_event report several events, sometime bp_event cannot go through to
user.

The root cause is attr->freq is 1 passed to kernel defaultly in bp
events, this make kernel calculate event period not as expect, make
sample period to 1 will change attr->freq to 0, to fix this problem.

This patch is similar with commit f92128 about tracepoint events:
    perf: Make the trace events sample period default to 1

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/CACV3sbLF8taiCq_VYW-sgRJyupeMzg58C7ZXfMe3xZUiH_Mx6w@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/parse-events.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a729945..74a5af4 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,6 +490,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 		attr.bp_len = HW_BREAKPOINT_LEN_4;
 
 	attr.type = PERF_TYPE_BREAKPOINT;
+	attr.sample_period = 1;
 
 	return add_event(list, idx, &attr, NULL);
 }
