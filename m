Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1FMOsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 10:48:35 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35607 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab1FMOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 10:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Iwlv27c9BDGVLSyT74HKlarfmkN7Y4jQMakjnpPi3lwJypBsDdCynqDCB6xFlJGx75
         oTDILhQqALTlygEVatkMKW58enR2CQbL0pQSDQAglr5UB/qQT6KG+GVtHlUbwb+dEvLG
         4m1t3rhxaWE8O8EiGaV9kwX2ShjczGWBMhCb8=
From: Namhyung Kim <namhyung@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] md/raid5: fix raid5_set_bi_hw_segments
Date: Mon, 13 Jun 2011 23:48:22 +0900
Message-Id: <1307976504-10215-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The @bio->bi_phys_segments consists of active stripes count in the
lower 16 bits and processed stripes count in the upper 16 bits. So
logical-OR operator should be bitwise one.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 346e69bfdab3..fa6ac70dc72f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -129,7 +129,7 @@ static inline int raid5_dec_bi_hw_segments(struct bio *bio)
 
 static inline void raid5_set_bi_hw_segments(struct bio *bio, unsigned int cnt)
 {
-	bio->bi_phys_segments = raid5_bi_phys_segments(bio) || (cnt << 16);
+	bio->bi_phys_segments = raid5_bi_phys_segments(bio) | (cnt << 16);
 }
 
 /* Find first data disk in a raid6 stripe */
-- 
1.7.5.2

