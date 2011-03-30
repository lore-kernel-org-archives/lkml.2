Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965374Ab1C3Vn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:43:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:61735 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933258Ab1C3VHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237388"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stf_xl@pop3.wp.pl, stf_xl@wp.pl, rjw@sisk.pl, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [128/275] PM / Hibernate: Return error code when alloc_image_page() fails
Message-Id: <20110330210608.765173E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stanislaw Gruszka <stf_xl@pop3.wp.pl>

commit 2e725a065b0153f0c449318da1923a120477633d upstream.

Currently we return 0 in swsusp_alloc() when alloc_image_page() fails.
Fix that.  Also remove unneeded "error" variable since the only
useful value of error is -ENOMEM.

[rjw: Fixed up the changelog and changed subject.]

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/power/snapshot.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/kernel/power/snapshot.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/snapshot.c	2011-03-29 22:51:16.709295620 -0700
+++ linux-2.6.35.y/kernel/power/snapshot.c	2011-03-29 23:53:44.733393061 -0700
@@ -1512,11 +1512,8 @@
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error = 0;
-
 	if (nr_highmem > 0) {
-		error = get_highmem_buffer(PG_ANY);
-		if (error)
+		if (get_highmem_buffer(PG_ANY))
 			goto err_out;
 		if (nr_highmem > alloc_highmem) {
 			nr_highmem -= alloc_highmem;
@@ -1539,7 +1536,7 @@
 
  err_out:
 	swsusp_free();
-	return error;
+	return -ENOMEM;
 }
 
 asmlinkage int swsusp_save(void)
