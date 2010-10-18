Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab0JRTSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:18:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:59382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab0JRTSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:18:45 -0400
Date: Mon, 18 Oct 2010 19:18:20 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, robert.richter@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
References: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Fix bogus AMD64 generic TLB events
Message-ID: <tip-ba0cef3d149ce4db293c572bf36ed352b11ce7b9@git.kernel.org>
Git-Commit-ID: ba0cef3d149ce4db293c572bf36ed352b11ce7b9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Oct 2010 19:18:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba0cef3d149ce4db293c572bf36ed352b11ce7b9
Gitweb:     http://git.kernel.org/tip/ba0cef3d149ce4db293c572bf36ed352b11ce7b9
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 15 Oct 2010 15:15:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 18 Oct 2010 19:58:48 +0200

perf_events: Fix bogus AMD64 generic TLB events

PERF_COUNT_HW_CACHE_DTLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x7 (to count all possibilities).

PERF_COUNT_HW_CACHE_ITLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x3 (to count all possibilities).

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: <stable@kernel.org> # as far back as it applies
LKML-Reference: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index c2897b7..46d5844 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -52,7 +52,7 @@ static __initconst const u64 amd_hw_cache_event_ids
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
+		[ C(RESULT_MISS)   ] = 0x0746, /* L1_DTLB_AND_L2_DLTB_MISS.ALL */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0,
@@ -66,7 +66,7 @@ static __initconst const u64 amd_hw_cache_event_ids
  [ C(ITLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
-		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
+		[ C(RESULT_MISS)   ] = 0x0385, /* L1_ITLB_AND_L2_ITLB_MISS.ALL */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = -1,
