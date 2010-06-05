Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab0FEEuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 00:50:51 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60833 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0FEEuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 00:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=TB2R2SNMJCKM3vlfCSWYqmngDpakXD5y3NC/YyMKu46g9yUUDlspYpp152AoKmzIG/
         2pW0L4ZJfbWDvdwrk5ylIY1CliLre5n/2JeUnRRBrgdjBLbVEvZfgjnktkOQ5Yih3HKK
         eQQUHr4fBh/ZVigYn6XoXpR5Jf+jfbg5YVu+w=
Subject: [PATCH] remove pointless debug printk in rt_ioctl_giwscan()
From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, bzolnier@gmail.com, roel.kluin@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 06:41:49 +0200
Message-ID: <1275712909.8509.25.camel@debian-hell>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This debug printk is only useful if you're debugging the staging drivers
2860 e 2870, but, if you're just using them, it becomes really annoying, because
it uselessly clobbers the kernel log. I guess this patch shouldn't really get merged,
but it's more like a request to remove these annoying debugging messages for normal users.
If I get any suggestion on how to implement this in a way acceptable to get it merged, I'll
be happy to create the "good" version  of the patch.

Thanks,

Giangiacomo

>From b24cc30ddad0bcd9a1fe00a7ecdd5dba4a3a4d06 Mon Sep 17 00:00:00 2001
From: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
Date: Sat, 5 Jun 2010 05:39:58 +0200
Subject: [PATCH] remove pointless debug printk in rt_ioctl_giwscan()


Signed-off-by: Giangiacomo Mariotti <giangiacomo.mariotti@gmail.com>
---
 drivers/staging/rt2860/sta_ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_ioctl.c
index de4b627..f9aa6f2 100644
--- a/drivers/staging/rt2860/sta_ioctl.c
+++ b/drivers/staging/rt2860/sta_ioctl.c
@@ -1116,9 +1116,9 @@ int rt_ioctl_giwscan(struct net_device *dev,
 
 	data->length = current_ev - extra;
 	pAdapter->StaCfg.bScanReqIsFromWebUI = FALSE;
-	DBGPRINT(RT_DEBUG_ERROR,
+	/*DBGPRINT(RT_DEBUG_ERROR,
 		 ("===>rt_ioctl_giwscan. %d(%d) BSS returned, data->length = %d\n",
-		  i, pAdapter->ScanTab.BssNr, data->length));
+		  i, pAdapter->ScanTab.BssNr, data->length));*/
 	return 0;
 }
 
-- 
1.7.1


