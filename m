Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935012Ab2C3Wwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:52:35 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab2C3VGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:06 -0400
Message-Id: <201203302105.q2UL57c5006303@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 16:14:40 -0400
Subject: [PATCH] arch/tile: fix pointer cast in cacheflush.c
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:07.0819 (UTC) FILETIME=[C9553BB0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pragmatically it couldn't be wrong to cast pointers to long to compare
them (since all kernel addresses are in the top half of VA space),
but it's more correct to cast to unsigned long.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/cacheflush.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/tile/lib/cacheflush.c b/arch/tile/lib/cacheflush.c
index 8928aac..6af2b97 100644
--- a/arch/tile/lib/cacheflush.c
+++ b/arch/tile/lib/cacheflush.c
@@ -109,7 +109,7 @@ void finv_buffer_remote(void *buffer, size_t size, int hfh)
 
 	/* Figure out how far back we need to go. */
 	base = p - (step_size * (load_count - 2));
-	if ((long)base < (long)buffer)
+	if ((unsigned long)base < (unsigned long)buffer)
 		base = buffer;
 
 	/*
-- 
1.6.5.2

