Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab1BYVit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:38:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:54283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1BYVir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:38:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=uLInal8Wnw7nsLb3kojm49vPA+ys3Jtaflvpr/I1OKlKrakaeBBoMCuCT2Vgz+cix
	Kti7v6y6NLbkxA55W1j7w==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH v5 3/9] writeback: convert variables to unsigned
Date: Fri, 25 Feb 2011 13:35:54 -0800
Message-Id: <1298669760-26344-4-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1298669760-26344-1-git-send-email-gthelen@google.com>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert two balance_dirty_pages() page counter variables (nr_reclaimable
and nr_writeback) from 'long' to 'unsigned long'.

These two variables are used to store results from global_page_state().
global_page_state() returns unsigned long and carefully sums per-cpu
counters explicitly avoiding returning a negative value.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
Changelog since v4:
- Created this patch for clarity.  Previously this patch was integrated within
  the "writeback: create dirty_info structure" patch.

 mm/page-writeback.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2cb01f6..4408e54 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -478,8 +478,10 @@ unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 static void balance_dirty_pages(struct address_space *mapping,
 				unsigned long write_chunk)
 {
-	long nr_reclaimable, bdi_nr_reclaimable;
-	long nr_writeback, bdi_nr_writeback;
+	unsigned long nr_reclaimable;
+	long bdi_nr_reclaimable;
+	unsigned long nr_writeback;
+	long bdi_nr_writeback;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
 	unsigned long bdi_thresh;
-- 
1.7.3.1

