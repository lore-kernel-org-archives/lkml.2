Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1BJDjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:39:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:54741 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1BJDja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:39:30 -0500
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH] staging: rts_pstor: fix read past end of buffer
Date: Thu, 10 Feb 2011 11:38:04 +0800
X-BOX-Message-Id: p1A3d4El023025
Message-ID: <1297309084-19839-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Thanks Dan Carpenter <error27@gmail.com> who helps to find this bug.
There are two places where we read one space past the end of buffer.

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/ms.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index dd59931..28d17c7 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -3361,8 +3361,8 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32
 	log_blk = (u16)(start_sector >> ms_card->block_shift);
 	start_page = (u8)(start_sector & ms_card->page_off);
 
-	for (seg_no = 0; seg_no < sizeof(ms_start_idx)/2; seg_no++) {
-		if (log_blk < ms_start_idx[seg_no+1])
+	for (seg_no = 0; seg_no < ARRAY_SIZE(ms_start_idx) - 1; seg_no++) {
+		if (log_blk < ms_start_idx[seg_no + 1])
 			break;
 	}
 
@@ -3494,8 +3494,8 @@ static int ms_rw_multi_sector(struct scsi_cmnd *srb, struct rtsx_chip *chip, u32
 
 		log_blk++;
 
-		for (seg_no = 0; seg_no < sizeof(ms_start_idx)/2; seg_no++) {
-			if (log_blk < ms_start_idx[seg_no+1])
+		for (seg_no = 0; seg_no < ARRAY_SIZE(ms_start_idx) - 1; seg_no++) {
+			if (log_blk < ms_start_idx[seg_no + 1])
 				break;
 		}
 
-- 
1.7.4

