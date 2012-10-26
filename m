Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab2JZH4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:56:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:52418 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757054Ab2JZH4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:56:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,653,1344236400"; 
   d="scan'208";a="238676430"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] kfifo: round up the fifo size power of 2
Date: Fri, 26 Oct 2012 15:56:57 +0800
Message-Id: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Say, if we want to allocate a filo with size of 6 bytes, it would be safer
to allocate 8 bytes instead of 4 bytes.
----
I know it works with rounddown_pow_of_two as well, since size is maintained
in the kfifo internal part. But, I'm quite curious why Stefani chose
rounddown_pow_of_two. To reduce memory?

Thanks,
Yuanhan Liu
-----

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 kernel/kfifo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/kfifo.c b/kernel/kfifo.c
index 59dcf5b..0f78378 100644
--- a/kernel/kfifo.c
+++ b/kernel/kfifo.c
@@ -39,11 +39,11 @@ int __kfifo_alloc(struct __kfifo *fifo, unsigned int size,
 		size_t esize, gfp_t gfp_mask)
 {
 	/*
-	 * round down to the next power of 2, since our 'let the indices
+	 * round up to the next power of 2, since our 'let the indices
 	 * wrap' technique works only in this case.
 	 */
 	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+		size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
@@ -84,7 +84,7 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
 	size /= esize;
 
 	if (!is_power_of_2(size))
-		size = rounddown_pow_of_two(size);
+		size = roundup_pow_of_two(size);
 
 	fifo->in = 0;
 	fifo->out = 0;
-- 
1.7.7.6

