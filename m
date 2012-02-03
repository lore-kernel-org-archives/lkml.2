Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2BCNXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:23:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51538 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2BCNXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:23:17 -0500
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>
Cc: Amit Sahrawat <a.sahrawat@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/2] mm: make do_writepages() use plugging
Date: Fri,  3 Feb 2012 18:57:06 +0530
Message-Id: <1328275626-5322-1-git-send-email-amit.sahrawat83@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will cover all the invocations for writepages to be called with
plugging support.

Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 mm/page-writeback.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 363ba70..2bea32c 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1866,14 +1866,18 @@ EXPORT_SYMBOL(generic_writepages);
 
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
+	struct blk_plug plug;
 	int ret;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+
+	blk_start_plug(&plug);
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+	blk_finish_plug(&plug);
 	return ret;
 }
 
-- 
1.7.2.3

