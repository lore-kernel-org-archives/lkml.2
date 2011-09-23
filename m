Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1IWXpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:45:22 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50082 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab1IWXpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:45:21 -0400
Subject: [PATCH REPOST] perf event, POWER 6: L1 cache read and write access
 event code fix]
From: "Carl E. Love" <cel@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, pmac@au1.ibm.com, bherren@au1.ibm.com,
        mingo@elte.hu, peterz@infradead.org, cel@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 16:45:17 -0700
Message-ID: <1316821517.20740.170.camel@oc5652146517.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, Paul, Peter, Ingo:

I posted this patch earlier this week.  I seemed to have missed copying
the message directly to each of you.  I have not seen anything on the
mailing list so I thought it best to repost the patch.  Thanks.

                   Carl Love
---------------------------------------------------------------------

The current L1 cache read event code 0x80082 only counts for thread 0. The
event code 0x280030 should be used to count events on thread 0 and 1. The
patch fixes the event code for the L1 cache read.

The current L1 cache write event code 0x80086 only counts for thread 0. The
event code 0x180032 should be used to count events on thread 0 and 1. The
patch fixes the event code for the L1 cache write.

FYI, the documentation lists three event codes for the L1 cache read event
and three event codes for the L1 cache write event.  The event description
for the event codes is as follows:

L1 cache read requests	0x80082  LSU 0 only
L1 cache read requests	0x8008A  LSU 1 only
L1 cache read requests	0x80030  LSU 1 or LSU 0, counter 2 only.

L1 cache store requests	0x80086  LSU 0 only
L1 cache store requests	0x8008E  LSU 1 only
L1 cache store requests	0x80032  LSU 0 or LSU 1, counter 1 only.

There can only be one request from either LSU 0 or 1 active at a time.

Signed-off-by: Carl Love <cel@us.ibm.com>
---
 arch/powerpc/kernel/power6-pmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 03b95e2..0bbc901 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -487,8 +487,8 @@ static int power6_generic_events[] = {
  */
 static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 	[C(L1D)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
-		[C(OP_READ)] = {	0x80082,	0x80080		},
-		[C(OP_WRITE)] = {	0x80086,	0x80088		},
+		[C(OP_READ)] = {	0x280030,	0x80080		},
+		[C(OP_WRITE)] = {	0x180032,	0x80088		},
 		[C(OP_PREFETCH)] = {	0x810a4,	0		},
 	},
 	[C(L1I)] = {		/* 	RESULT_ACCESS	RESULT_MISS */


