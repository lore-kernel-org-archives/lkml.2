Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0FIKTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:19:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36459 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab0FIKS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:18:58 -0400
Date: Wed, 9 Jun 2010 10:18:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix build breakage for architecutes without atomic64_t
Message-ID: <tip-7be7923633a142402266d642ccebf74f556a649b@git.kernel.org>
Git-Commit-ID: 7be7923633a142402266d642ccebf74f556a649b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:18:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7be7923633a142402266d642ccebf74f556a649b
Gitweb:     http://git.kernel.org/tip/7be7923633a142402266d642ccebf74f556a649b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 9 Jun 2010 11:57:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 12:03:00 +0200

perf: Fix build breakage for architecutes without atomic64_t

The local64.h include dependency was not dependent on PERF_EVENT=y,
which meant that arch's without atomic64_t support ended up including
it and failed to build.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/perf_event.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 7342979..1218d05 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -462,6 +462,7 @@ enum perf_callchain_context {
 
 #ifdef CONFIG_PERF_EVENTS
 # include <asm/perf_event.h>
+# include <asm/local64.h>
 #endif
 
 struct perf_guest_info_callbacks {
@@ -487,7 +488,6 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
-#include <asm/local64.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
