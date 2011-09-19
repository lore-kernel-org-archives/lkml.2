Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab1ISV1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:27:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64682 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab1ISV0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:45 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SeSQMFz2DmQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=NufY4J3AAAAA:8 a=meVymXHHAAAA:8 a=U_QR791Gu2yRSeb4sz8A:9 a=jEp0ucaQiEUA:10 a=re9sYKne76oA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110919212640.688732950@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 19 Sep 2011 17:20:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: [RFC][PATCH 2/5] mm: Switch mod_state() to __this_cpu_read()
References: <20110919212040.745370781@goodmis.org>
Content-Disposition: inline; filename=0002-mm-Switch-mod_state-to-__this_cpu_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The code in mod_state() is already made to handle the raciness of
this_cpu_read(). Have the code use __this_cpu_read() instead so
the debug code does not trigger warnings about it.

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/vmstat.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index d52b13d..41a843f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -328,9 +328,9 @@ static inline void mod_state(struct zone *zone,
 		 * Most of the time the thresholds are the same anyways
 		 * for all cpus in a zone.
 		 */
-		t = this_cpu_read(pcp->stat_threshold);
+		t = __this_cpu_read(pcp->stat_threshold);
 
-		o = this_cpu_read(*p);
+		o = __this_cpu_read(*p);
 		n = delta + o;
 
 		if (n > t || n < -t) {
-- 
1.7.5.4


