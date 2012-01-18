Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2ARPkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 10:40:25 -0500
Received: from relay2.sgi.com ([192.48.179.30]:34219 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755445Ab2ARPkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 10:40:24 -0500
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: uninitialized spinlocks in tlb_uv.c
Cc: mingo@elte.hu, x86@kernel.org
Message-Id: <E1RnXd1-0003wU-PM@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 18 Jan 2012 09:40:47 -0600
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Initialize two spinlocks in tlb_uv.c.

The lack of explicit initialization seems to be functionally harmless (the
locks are initialized to 0's), but it is diagnosed when these are turned on:
        CONFIG_DEBUG_SPINLOCK=y
        CONFIG_DEBUG_MUTEXES=y
        CONFIG_DEBUG_LOCK_ALLOC=y
        CONFIG_LOCKDEP=y

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/platform/uv/tlb_uv.c |    2 ++
 1 file changed, 2 insertions(+)

Index: 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- 120113.linux-3.2.1.orig/arch/x86/platform/uv/tlb_uv.c
+++ 120113.linux-3.2.1/arch/x86/platform/uv/tlb_uv.c
@@ -1851,6 +1851,8 @@ static void __init init_per_cpu_tunables
 		bcp->cong_reps			= congested_reps;
 		bcp->cong_period		= congested_period;
 		bcp->clocks_per_100_usec =	usec_2_cycles(100);
+		spin_lock_init(&bcp->queue_lock);
+		spin_lock_init(&bcp->uvhub_lock);
 	}
 }
 
