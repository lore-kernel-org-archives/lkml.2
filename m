Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab1IHBag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:30:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54420 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748Ab1IHB3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:29:25 -0400
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] Fix sparse warnings
Date: Thu,  8 Sep 2011 08:29:13 +0700
Message-Id: <1315445357-14338-2-git-send-email-ngupta@vflare.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
References: <1315445357-14338-1-git-send-email-ngupta@vflare.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/zram/zram_drv.c |    3 ++-
 drivers/staging/zram/zram_drv.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d70ec1a..03ec5a2 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -684,7 +684,8 @@ fail:
 	return ret;
 }
 
-void zram_slot_free_notify(struct block_device *bdev, unsigned long index)
+static void zram_slot_free_notify(struct block_device *bdev,
+				unsigned long index)
 {
 	struct zram *zram;
 
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index abe5221..70ce886 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -47,7 +47,7 @@ static const unsigned default_disksize_perc_ram = 25;
  * Pages that compress to size greater than this are stored
  * uncompressed in memory.
  */
-static const unsigned max_zpage_size = PAGE_SIZE / 4 * 3;
+static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 
 /*
  * NOTE: max_zpage_size must be less than or equal to:
-- 
1.7.6

