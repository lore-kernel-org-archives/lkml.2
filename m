Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2E3Bm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:42:56 -0400
Received: from masquerade.micron.com ([137.201.242.130]:7652 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab2E3Bmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:42:55 -0400
Message-ID: <4FC57B1B.5010901@micron.com>
Date: Tue, 29 May 2012 18:42:51 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 05/11] mtip32xx: Set block queue boundary variables
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--1.776600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Set the following block queue boundary variables
	* max_hw_sectors
	* max_segment_size
	* nr_requests

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 9fe897d..801e70c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3631,7 +3631,11 @@ skip_create_disk:
 	set_bit(QUEUE_FLAG_NONROT, &dd->queue->queue_flags);
 	blk_queue_max_segments(dd->queue, MTIP_MAX_SG);
 	blk_queue_physical_block_size(dd->queue, 4096);
+	blk_queue_max_hw_sectors(dd->queue, 0xffff);
+	blk_queue_max_segment_size(dd->queue, 0x400000);
 	blk_queue_io_min(dd->queue, 4096);
+	dd->queue->nr_requests = 255;
+
 	/*
 	 * write back cache is not supported in the device. FUA depends on
 	 * write back cache support, hence setting flush support to zero.
-- 
1.7.1

