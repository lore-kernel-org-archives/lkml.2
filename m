Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab1C3VPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:15:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:44838 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965273Ab1C3VKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621239350"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: rjw@sisk.pl, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [254/275] PM / Hibernate: Improve comments in hibernate_preallocate_memory()
Message-Id: <20110330210821.1FC8B3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

[ upstream commit 266f1a25eff5ff98c498d7754a419aacfd88f71c ]

One comment in hibernate_preallocate_memory() is wrong, so fix it and
add one more comment to clarify the meaning of the fixed one.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/power/snapshot.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/kernel/power/snapshot.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/snapshot.c	2011-03-29 23:03:00.951275828 -0700
+++ linux-2.6.35.y/kernel/power/snapshot.c	2011-03-29 23:53:44.143408156 -0700
@@ -1318,12 +1318,14 @@
 
 	/* Compute the maximum number of saveable pages to leave in memory. */
 	max_size = (count - (size + PAGES_FOR_IO)) / 2 - 2 * SPARE_PAGES;
+	/* Compute the desired number of image pages specified by image_size. */
 	size = DIV_ROUND_UP(image_size, PAGE_SIZE);
 	if (size > max_size)
 		size = max_size;
 	/*
-	 * If the maximum is not less than the current number of saveable pages
-	 * in memory, allocate page frames for the image and we're done.
+	 * If the desired number of image pages is at least as large as the
+	 * current number of saveable pages in memory, allocate page frames for
+	 * the image and we're done.
 	 */
 	if (size >= saveable) {
 		pages = preallocate_image_highmem(save_highmem);
