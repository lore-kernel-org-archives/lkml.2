Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab1JWGeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1JWGeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:10 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:37 2011
Message-Id: <20111023062537.648175007@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:30 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Pihet <j-pihet@ti.com>, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [02/27] ARM: 7117/1: perf: fix HW_CACHE_* events on Cortex-A9
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 29a541f6c1f6e4a85628bb86071b9e72c9f8be2c upstream.

Using COHERENT_LINE_{MISS,HIT} for cache misses and references
respectively is completely wrong. Instead, use the L1D events which
are a better and more useful approximation despite ignoring instruction
traffic.

Reported-by: Alasdair Grant <alasdair.grant@arm.com>
Reported-by: Matt Horsnell <matt.horsnell@arm.com>
Reported-by: Michael Williams <michael.williams@arm.com>
Cc: Jean Pihet <j-pihet@ti.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/perf_event_v7.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -264,8 +264,8 @@ static const unsigned armv7_a9_perf_map[
 	[PERF_COUNT_HW_CPU_CYCLES]	    = ARMV7_PERFCTR_CPU_CYCLES,
 	[PERF_COUNT_HW_INSTRUCTIONS]	    =
 					ARMV7_PERFCTR_INST_OUT_OF_RENAME_STAGE,
-	[PERF_COUNT_HW_CACHE_REFERENCES]    = ARMV7_PERFCTR_COHERENT_LINE_HIT,
-	[PERF_COUNT_HW_CACHE_MISSES]	    = ARMV7_PERFCTR_COHERENT_LINE_MISS,
+	[PERF_COUNT_HW_CACHE_REFERENCES]    = ARMV7_PERFCTR_DCACHE_ACCESS,
+	[PERF_COUNT_HW_CACHE_MISSES]	    = ARMV7_PERFCTR_DCACHE_REFILL,
 	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = ARMV7_PERFCTR_PC_WRITE,
 	[PERF_COUNT_HW_BRANCH_MISSES]	    = ARMV7_PERFCTR_PC_BRANCH_MIS_PRED,
 	[PERF_COUNT_HW_BUS_CYCLES]	    = ARMV7_PERFCTR_CLOCK_CYCLES,


