Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653Ab2AMPyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 10:54:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63742 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab2AMPxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 10:53:54 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 5/7] s390/char: use for_each_clear_bit
Date: Sat, 14 Jan 2012 00:53:22 +0900
Message-Id: <1326470004-10096-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
References: <1326470004-10096-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_clear_bit() to iterate over all the cleared bit in a
memory region.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/sclp_cmd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 0b54a91..168525a 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -441,9 +441,8 @@ static int sclp_mem_notifier(struct notifier_block *nb,
 	start = arg->start_pfn << PAGE_SHIFT;
 	size = arg->nr_pages << PAGE_SHIFT;
 	mutex_lock(&sclp_mem_mutex);
-	for (id = 0; id <= sclp_max_storage_id; id++)
-		if (!test_bit(id, sclp_storage_ids))
-			sclp_attach_storage(id);
+	for_each_clear_bit(id, sclp_storage_ids, sclp_max_storage_id + 1)
+		sclp_attach_storage(id);
 	switch (action) {
 	case MEM_ONLINE:
 	case MEM_GOING_OFFLINE:
-- 
1.7.4.4

