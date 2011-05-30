Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664Ab1E3Mzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:55:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39568 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab1E3Mzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=H+4NVmkN6EcnTwmCR9Euf2qh/clMjLqGV/xiJ0K1rEC0XiiSMes3PtSgYaPEe8yNaF
         zWR6tQcPMkG6z6pm1Pj5l77v2V+BJmKtEqLb+47XWGWvGBKO8pmENm311hI3wWtBvYE6
         00meeILLRMBjakmBD6SaoYIR/tHt3CvoMVviY=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, NeilBrown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Subject: [PATCH] md: use proper little-endian bitops
Date: Mon, 30 May 2011 21:56:20 +0900
Message-Id: <1306760180-4309-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using __test_and_{set,clear}_bit_le() with ignoring its return value
can be replaced with __{set,clear}_bit_le().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
---
 drivers/md/bitmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 70bd738..52fa6cf 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -856,7 +856,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			__test_and_set_bit_le(bit, kaddr);
+			__set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1228,7 +1228,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 						clear_bit(file_page_offset(bitmap, j),
 							  paddr);
 					else
-						__test_and_clear_bit_le(file_page_offset(bitmap, j),
+						__clear_bit_le(file_page_offset(bitmap, j),
 							       paddr);
 					kunmap_atomic(paddr, KM_USER0);
 				} else
-- 
1.7.4.4

