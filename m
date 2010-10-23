Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0JWIZT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:25:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55104 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab0JWIZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:25:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=u7VLbzkVc+ljGsbQb5yW4qKbKmSmOTvE6xIyQNnJJXXXLUUvxPHnjArzBINM+Lg3/3
         6MGPUxRxT6Bkpiw2RoM4grg/ud2tjVjKSdoZI/aYCdGUDLgpb7+fvUjjkfGFChEJSfz5
         qDhfJaacY+cYiEW9bwNhPV3zGkXZqdfHBooHo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, Jens Axboe <jaxboe@fusionio.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] block: cciss: fix information leak to userland
Date: Sat, 23 Oct 2010 12:25:11 +0400
Message-Id: <1287822311-14783-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Structure IOCTL_Command_struct is copied to userland with some
padding fields at the end of the struct unitialized.
It leads to leaking of stack memory.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 drivers/block/cciss.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 762a81a..cd08324 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1142,6 +1142,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
-- 
1.7.0.4

