Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2AMPyD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:54:03 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43115 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab2AMPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:58 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-usb@vger.kernel.org
Subject: [PATCH 6/7] uwb: use for_each_clear_bit
Date: Sat, 14 Jan 2012 00:53:23 +0900
Message-Id: <1326470004-10096-7-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-usb@vger.kernel.org
---
 drivers/uwb/allocator.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/uwb/allocator.c b/drivers/uwb/allocator.c
index e45e673..6e3e713 100644
--- a/drivers/uwb/allocator.c
+++ b/drivers/uwb/allocator.c
@@ -334,10 +334,8 @@ int uwb_rsv_find_best_allocation(struct uwb_rsv *rsv, struct uwb_mas_bm *availab
 
 
 	/* fill the not available vector from the available bm */
-	for (bit_index = 0; bit_index < UWB_NUM_MAS; bit_index++) {
-		if (!test_bit(bit_index, available->bm))
-			ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
-	}
+	for_each_clear_bit(bit_index, available->bm, UWB_NUM_MAS)
+		ai->bm[bit_index] = UWB_RSV_MAS_NOT_AVAIL;
 
 	if (ai->max_interval == 1) {
 		get_row_descriptors(ai);
-- 
1.7.4.4

