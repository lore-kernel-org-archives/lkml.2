Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934028Ab1JEJx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 05:53:29 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35498 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1JEJx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 05:53:27 -0400
From: Rabin Vincent <rabin@rab.in>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH] block: fix UUID string buffer length
Date: Wed,  5 Oct 2011 15:22:44 +0530
Message-Id: <1317808364-21081-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UUID string buffer is several bytes shorter than what is actually
required, because the space for the hyphens hasn't been taken into
account.  Fix it, while also making it a regular char[] rather than a
u8[] to make it clear what we're storing here.

Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 block/genhd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8dfa21e..fa955b5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -736,7 +736,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char uuid[sizeof("xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -755,7 +755,7 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid[0] = 0;
+			uuid[0] = '\0';
 			if (part->info)
 				part_unpack_uuid(part->info->uuid, uuid);
 
-- 
1.7.5.4

