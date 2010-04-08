Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab0DHKUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:20:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758473Ab0DHKUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:20:10 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] loop: Update mtime when writing using aops
Date: Thu, 8 Apr 2010 15:51:37 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-desktop; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004081551.37824.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update mtime when writing to backing filesystem using the address space
operations write_begin and write_end.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cb69929..8546d12 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -237,6 +237,8 @@ static int do_lo_send_aops(struct loop_device *lo, struct bio_vec *bvec,
 		if (ret)
 			goto fail;
 
+		file_update_time(file);
+
 		transfer_result = lo_do_transfer(lo, WRITE, page, offset,
 				bvec->bv_page, bv_offs, size, IV);
 		copied = size;
