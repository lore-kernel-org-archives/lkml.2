Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab2I2HLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:11:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48159 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2I2HLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:11:19 -0400
Date: Sat, 29 Sep 2012 10:11:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [patch 1/2] memstick: use after free in msb_disk_release()
Message-ID: <20120929071104.GB10993@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code dereferenced "msb" after freeing it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index c815fe5..a8e8915 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1983,9 +1983,9 @@ static int msb_disk_release(struct gendisk *disk)
 			msb->usage_count--;
 
 		if (!msb->usage_count) {
-			kfree(msb);
 			disk->private_data = NULL;
 			idr_remove(&msb_disk_idr, msb->disk_id);
+			kfree(msb);
 			put_disk(disk);
 		}
 	}
