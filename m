Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1CATho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:44 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52544 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab1CAThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:31 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 14:37:17 EST
Message-Id: <201103011931.p21JV3uD010192@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Feb 2011 08:46:38 -0500
Subject: [PATCH] arch/tile: Fix atomic_read() definition to use ACCESS_ONCE
In-Reply-To: <1297703506.5226.121.camel@laptop>
To: linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 01 Mar 2011 19:31:05.0577 (UTC) FILETIME=[35202D90:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the volatile cast which forces the compiler to emit the load.
Suggested by Peter Zijlstra <peterz@infradead.org>.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/atomic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index b8c49f9..75a1602 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -32,7 +32,7 @@
  */
 static inline int atomic_read(const atomic_t *v)
 {
-       return v->counter;
+	return ACCESS_ONCE(v->counter);
 }
 
 /**
-- 
1.6.5.2

