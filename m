Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0JVXyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab0JVXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cJncFtkjMHMxCTw6ag1ctW1s1INPLz/FuMviDJjg2PCO+FPC4nlPcSxvoru2X9A5F1
         ziiwI6sRXB4V+Wx//h/oe2pR4naUeKVa4BAo0aSB4ywKhvlDCBQhaNuYDPgkHyFFaaOd
         14qcmSCibHmEHywYpycjPAsXT72GCEO2R7XCk=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 06/29] memstick: mspro: kill the BKL
Date: Sat, 23 Oct 2010 01:53:34 +0200
Message-Id: <1287791637-10329-7-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mspro_block_disk_lock already protects the code.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 5dc8fd7..a979c9d 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -36,7 +36,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
-	lock_kernel();
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -48,8 +47,6 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-	unlock_kernel();
-
 	return rc;
 }
 
@@ -74,16 +71,13 @@ static int mspro_block_disk_release(struct gendisk *disk)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-
 	return 0;
 }
 
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
 	int ret;
-	lock_kernel();
 	ret = mspro_block_disk_release(disk);
-	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.1

