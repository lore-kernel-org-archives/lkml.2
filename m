Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1ALAvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:51:21 -0500
Received: from mail160.messagelabs.com ([216.82.253.99]:53599 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715Ab1ALAvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:51:18 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-160.messagelabs.com!1294793477!8409161!3
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.32]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Date: Tue, 11 Jan 2011 18:46:10 -0600
Subject: [PATCH] mtd_blkdevs: local symbols should be static
Thread-Topic: [PATCH] mtd_blkdevs: local symbols should be static
Thread-Index: Acux8hsVXOgyVaITRIq4pEdhos33uw==
Message-ID: <0D753D10438DA54287A00B027084269764CE0E550B@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0C0pWhn022979

The function blktrans_dev_release and blktrans_dev_put are only used
locally in this file and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index cb20c67..3bcdf6c 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -40,7 +40,7 @@
 static LIST_HEAD(blktrans_majors);
 static DEFINE_MUTEX(blktrans_ref_mutex);
 
-void blktrans_dev_release(struct kref *kref)
+static void blktrans_dev_release(struct kref *kref)
 {
 	struct mtd_blktrans_dev *dev =
 		container_of(kref, struct mtd_blktrans_dev, ref);
@@ -67,7 +67,7 @@ unlock:
 	return dev;
 }
 
-void blktrans_dev_put(struct mtd_blktrans_dev *dev)
+static void blktrans_dev_put(struct mtd_blktrans_dev *dev)
 {
 	mutex_lock(&blktrans_ref_mutex);
 	kref_put(&dev->ref, blktrans_dev_release);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
