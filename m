Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab0FJMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:25:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:47540 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab0FJMZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:25:38 -0400
Date: Thu, 10 Jun 2010 12:25:08 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4c10cb56.5120e30a.2eb4.ffffc3de@mx.google.com>
References: <4c10cb56.5120e30a.2eb4.ffffc3de@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix Intel Westmere event constraints
Message-ID: <tip-d11007703c31db534674ebeeb9eb047bbbe758bd@git.kernel.org>
Git-Commit-ID: d11007703c31db534674ebeeb9eb047bbbe758bd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 10 Jun 2010 12:25:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d11007703c31db534674ebeeb9eb047bbbe758bd
Gitweb:     http://git.kernel.org/tip/d11007703c31db534674ebeeb9eb047bbbe758bd
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 10 Jun 2010 13:25:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 10 Jun 2010 14:16:32 +0200

perf_events: Fix Intel Westmere event constraints

Based on Intel Vol3b (March 2010), the event
SNOOPQ_REQUEST_OUTSTANDING is restricted to counters 0,1 so
update the event table for Intel Westmere accordingly.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: perfmon2-devel@lists.sf.net
Cc: eranian@gmail.com
Cc: <stable@kernel.org> # .34.x
LKML-Reference: <4c10cb56.5120e30a.2eb4.ffffc3de@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fdbc652..214ac86 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -72,6 +72,7 @@ static struct event_constraint intel_westmere_event_constraints[] =
 	INTEL_EVENT_CONSTRAINT(0x51, 0x3), /* L1D */
 	INTEL_EVENT_CONSTRAINT(0x60, 0x1), /* OFFCORE_REQUESTS_OUTSTANDING */
 	INTEL_EVENT_CONSTRAINT(0x63, 0x3), /* CACHE_LOCK_CYCLES */
+	INTEL_EVENT_CONSTRAINT(0xb3, 0x1), /* SNOOPQ_REQUEST_OUTSTANDING */
 	EVENT_CONSTRAINT_END
 };
 
