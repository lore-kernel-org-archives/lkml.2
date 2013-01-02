Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab3ABFY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:24:28 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:29034 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab3ABFYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:24:25 -0500
Message-ID: <1357104262.2182.5.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH 2/3] staging: zram: show correct disksize
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Date: Tue, 01 Jan 2013 21:24:22 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->disksize variable stores values in units of bytes,
print the correct size in Kb

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
---
 drivers/staging/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 8115be9..10d7592 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -126,8 +126,7 @@ static void zram_set_disksize(struct zram *zram, size_t totalram_bytes)
 		"\tMemory Size: %zu kB\n"
 		"\tSize you selected: %llu kB\n"
 		"Continuing anyway ...\n",
-		totalram_bytes >> 10, zram->disksize
-		);
+		totalram_bytes >> 10, zram->disksize >> 10);
 	}
 
 	zram->disksize &= PAGE_MASK;
-- 
1.7.11.7




