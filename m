Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013Ab2C3VGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:16 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934937Ab2C3VFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:54 -0400
Message-Id: <201203302105.q2UL55Po006295@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:43:20 -0400
Subject: [PATCH] arch/tile: fix bug in delay_backoff()
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:06.0054 (UTC) FILETIME=[C847EA60:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were carefully computing a value to use for the number of loops
to spin for, and then ignoring it.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/spinlock_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/lib/spinlock_common.h b/arch/tile/lib/spinlock_common.h
index c101098..6ac3750 100644
--- a/arch/tile/lib/spinlock_common.h
+++ b/arch/tile/lib/spinlock_common.h
@@ -60,5 +60,5 @@ static void delay_backoff(int iterations)
 	loops += __insn_crc32_32(stack_pointer, get_cycles_low()) &
 		(loops - 1);
 
-	relax(1 << exponent);
+	relax(loops);
 }
-- 
1.6.5.2

