Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab1FZF5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 01:57:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49791 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab1FZF4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 01:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gAAEmXel6pwomW3eyLf4DnUmZ+QZ4JTAAdcEjsBMt/9OuhUyzw5FVsivIQKCYFy32y
         SWUrc37A39RdRYd6nyN4LkExWLyLPgsXh2Kl/ICfVcKyFFBmZcpo0Gx7KIyPtng4G8rZ
         dxj7ucrUjcrXvnCLF06moaYxwJOIbQTndbcOM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, NeilBrown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Subject: [PATCH resend 3/6] md: use proper little-endian bitops
Date: Sun, 26 Jun 2011 14:57:53 +0900
Message-Id: <1309067876-3537-4-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
References: <1309067876-3537-1-git-send-email-akinobu.mita@gmail.com>
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
index 574b09a..870a7fc 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -932,7 +932,7 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			set_bit(bit, kaddr);
 		else
-			__test_and_set_bit_le(bit, kaddr);
+			__set_bit_le(bit, kaddr);
 		kunmap_atomic(kaddr, KM_USER0);
 		PRINTK("set file bit %lu page %lu\n", bit, page->index);
 	}
@@ -1304,7 +1304,7 @@ void bitmap_daemon_work(mddev_t *mddev)
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

