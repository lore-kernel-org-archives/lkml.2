Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab1IZCZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 22:25:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:37059 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280Ab1IZCZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 22:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,441,1312182000"; 
   d="scan'208";a="67383168"
Subject: [patch]mm: add more blk plug
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 10:30:26 +0800
Message-ID: <1317004226.29510.172.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some filesystems implement .writepages. We don't have blk plug
in such filesystems for .writepages.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0e309cd..b9e73a1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1253,13 +1253,16 @@ EXPORT_SYMBOL(generic_writepages);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	int ret;
+	struct blk_plug plug;
 
 	if (wbc->nr_to_write <= 0)
 		return 0;
+	blk_start_plug(&plug);
 	if (mapping->a_ops->writepages)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+	blk_finish_plug(&plug);
 	return ret;
 }
 


