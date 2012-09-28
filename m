Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab2I1KAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 06:00:11 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9035 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab2I1KAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 06:00:09 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Glauber Costa <glommer@parallels.com>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH] make GFP_NOTRACK flag unconditional
Date: Fri, 28 Sep 2012 13:56:34 +0400
Message-Id: <1348826194-21781-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a general sentiment in a recent discussion (See
https://lkml.org/lkml/2012/9/18/258) that the __GFP flags should be
defined unconditionally. Currently, the only offender is GFP_NOTRACK,
which is conditional to KMEMCHECK.

This simple patch makes it unconditional.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Christoph Lameter <cl@linux.com>
CC: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/gfp.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f9bc873..02c1c97 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -30,11 +30,7 @@ struct vm_area_struct;
 #define ___GFP_HARDWALL		0x20000u
 #define ___GFP_THISNODE		0x40000u
 #define ___GFP_RECLAIMABLE	0x80000u
-#ifdef CONFIG_KMEMCHECK
 #define ___GFP_NOTRACK		0x200000u
-#else
-#define ___GFP_NOTRACK		0
-#endif
 #define ___GFP_OTHER_NODE	0x800000u
 #define ___GFP_WRITE		0x1000000u
 
-- 
1.7.11.4

