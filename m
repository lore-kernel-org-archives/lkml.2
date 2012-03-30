Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab2C3VGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:06:30 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41969 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935011Ab2C3VG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:27 -0400
Message-Id: <201203302105.q2UL5AJZ006313@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 16:27:20 -0400
Subject: [PATCH] arch/tile: remove bogus performance optimization
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:10.0866 (UTC) FILETIME=[CB262B20:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were re-homing the initial task's kernel stack on the boot cpu,
but in fact it's better to let it stay globally homed, since that
task isn't bound to the boot cpu anyway.  This is more of a general
cleanup than an actual performance optimization, but it removes
code, which is a good thing. :-)

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/init.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 5276f05..0138e8c 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -250,11 +250,6 @@ static pgprot_t __init init_pgprot(ulong address)
 		return construct_pgprot(PAGE_KERNEL_RO, PAGE_HOME_IMMUTABLE);
 	}
 
-	/* As a performance optimization, keep the boot init stack here. */
-	if (address >= (ulong)&init_thread_union &&
-	    address < (ulong)&init_thread_union + THREAD_SIZE)
-		return construct_pgprot(PAGE_KERNEL, smp_processor_id());
-
 #ifndef __tilegx__
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 	/* Force the atomic_locks[] array page to be hash-for-home. */
-- 
1.6.5.2

