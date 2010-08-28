Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab0H1HKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 03:10:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0H1HKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 03:10:41 -0400
Date: Sat, 28 Aug 2010 10:09:05 +0300
From: Shahar Havivi <shaharh@redhat.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: [PATCH] zram: free device memory when init fails
Message-ID: <20100828070901.GA31943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shahar Havivi <shaharh@redhat.com>
---
 drivers/staging/zram/zram_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 77d4d71..e8d2319 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -769,6 +769,7 @@ static int __init zram_init(void)
 free_devices:
 	while (dev_id)
 		destroy_device(&devices[--dev_id]);
+    kfree(devices);
 unregister:
 	unregister_blkdev(zram_major, "zram");
 out:
-- 
1.7.2.1

