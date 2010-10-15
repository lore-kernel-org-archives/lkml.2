Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0JONrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 09:47:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50942 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab0JONrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 09:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=QmG1yr1/O908smivFmyaX1w9/DjX/xwszaXcgZPggu1kMbwQd+Er4m4uTgyMFyABuu
         pN6EYXSJFPLmgkbavPnA==
Message-ID: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 15 Oct 2010 15:15:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix bogus AMD64 generic TLB events
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PERF_COUNT_HW_CACHE_DTLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x7 (to count all possibilities).

PERF_COUNT_HW_CACHE_ITLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x3 (to count all possibilities).

Signed-off-by: Stephane Eranian <eranian@google.com>

---

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
