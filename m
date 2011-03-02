Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab1CBL4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:56:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52258 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115Ab1CBL4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QYcLx9FpIkOu6PjQCxzt0Lyc6x70cpjowbvsBrwDJp2dRzSz+wrrDkTMS52AV/LtJp
         5Z4sliMtcggEyacPR0Wspk7zwaBPENjPbIQe8h0okKHHv7oxZtB+6XA9REA38UUqBcCr
         +B5mom+92vcYjPLvbLMqiqnq/hoU52xbkJUvs=
From: namei.unix@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block/genhd: Change some numerals into macros
Date: Wed,  2 Mar 2011 19:56:25 +0800
Message-Id: <1299066985-32030-1-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the numerals in the diskstats_show() into the macros.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 block/genhd.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index af9e7f8..00c102a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1164,14 +1164,14 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
-			   part_stat_read(hd, ios[0]),
-			   part_stat_read(hd, merges[0]),
-			   (unsigned long long)part_stat_read(hd, sectors[0]),
-			   jiffies_to_msecs(part_stat_read(hd, ticks[0])),
-			   part_stat_read(hd, ios[1]),
-			   part_stat_read(hd, merges[1]),
-			   (unsigned long long)part_stat_read(hd, sectors[1]),
-			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
+			   part_stat_read(hd, ios[READ]),
+			   part_stat_read(hd, merges[READ]),
+			   (unsigned long long)part_stat_read(hd, sectors[READ]),
+			   jiffies_to_msecs(part_stat_read(hd, ticks[READ])),
+			   part_stat_read(hd, ios[WRITE]),
+			   part_stat_read(hd, merges[WRITE]),
+			   (unsigned long long)part_stat_read(hd, sectors[WRITE]),
+			   jiffies_to_msecs(part_stat_read(hd, ticks[WRITE])),
 			   part_in_flight(hd),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
-- 
1.7.0.4

