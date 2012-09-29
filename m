Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2I2HLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:11:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30058 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2I2HLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:11:51 -0400
Date: Sat, 29 Sep 2012 10:11:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [patch 2/2] memstick: memory leak on error in msb_ftl_scan()
Message-ID: <20120929071138.GC10993@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to free "overwrite_flags" before returning.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index a8e8915..1f9d5cf 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -1408,8 +1408,10 @@ static int msb_ftl_scan(struct msb_data *msb)
 			msb_mark_block_used(msb, pba);
 			msb_erase_block(msb, pba);
 			continue;
-		} else if (error)
+		} else if (error) {
+			kfree(overwrite_flags);
 			return error;
+		}
 
 		lba = be16_to_cpu(extra.logical_address);
 		managment_flag = extra.management_flag;
