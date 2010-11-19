Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab0KSWEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:04:09 -0500
Received: from kroah.org ([198.145.64.141]:52802 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757877Ab0KSWEC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:02 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:22 2010
Message-Id: <20101119220122.517539673@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [04/66] perf_events: Fix bogus AMD64 generic TLB events
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stephane Eranian <eranian@google.com>

commit ba0cef3d149ce4db293c572bf36ed352b11ce7b9 upstream.

PERF_COUNT_HW_CACHE_DTLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x7 (to count all possibilities).

PERF_COUNT_HW_CACHE_ITLB:READ:MISS had a bogus umask value of 0 which
counts nothing. Needed to be 0x3 (to count all possibilities).

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <4cb85478.41e9d80a.44e2.3f00@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/perf_event_amd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -52,7 +52,7 @@ static __initconst const u64 amd_hw_cach
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
-		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
+		[ C(RESULT_MISS)   ] = 0x0746, /* L1_DTLB_AND_L2_DLTB_MISS.ALL */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0,
@@ -66,7 +66,7 @@ static __initconst const u64 amd_hw_cach
  [ C(ITLB) ] = {
 	[ C(OP_READ) ] = {
 		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
-		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
+		[ C(RESULT_MISS)   ] = 0x0385, /* L1_ITLB_AND_L2_ITLB_MISS.ALL */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = -1,


