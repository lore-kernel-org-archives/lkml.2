Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2IPJAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:00:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14283 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab2IPJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:00:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6836"; a="237334507"
From: Tatyana Brokhman <tlinder@codeaurora.org>
To: axboe@kernel.dk
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Tatyana Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND 1/2] block: Expose kblock_schedule_delayed_work()
Date: Sun, 16 Sep 2012 12:00:07 +0300
Message-Id: <1347786008-6310-2-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1347786008-6310-1-git-send-email-tlinder@codeaurora.org>
References: <1347786008-6310-1-git-send-email-tlinder@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is exported in blk-core.c to be used in other modules
but it's definition in h file is missing.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

---
 include/linux/blkdev.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a2ab7c..6929194 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1208,6 +1208,8 @@ static inline void put_dev_sector(Sector p)
 
 struct work_struct;
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
+int kblockd_schedule_delayed_work(struct request_queue *q,
+			struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
-- 
1.7.6
--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. 
Is a member of Code Aurora Forum, hosted by the Linux Foundation
