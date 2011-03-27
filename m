Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1C0Hoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 03:44:39 -0400
Received: from mail3-164.sinamail.sina.com.cn ([202.108.3.164]:61053 "EHLO
	smtp3-76.sina.com.cn" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751835Ab1C0Hoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 03:44:38 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Mar 2011 03:44:38 EDT
X-Originating-IP: [114.243.73.161]
Date: Sun, 27 Mar 2011 15:22:08 +0800 
From: zhdxzx@sina.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] uio: fix allocating minor id for uio device
MIME-Version: 1.0
X-Priority: 3
X-MessageID: 1301210528.46.98496
X-Mailer: Sina WebMail 4.0
Content-Type: text/plain; charset=GBK
Message-Id: <20110327072208.7DFD6D7A07E@mail3-130.sinamail.sina.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2R7j1Bv003653

The number of uio devices that could be used should be less than UIO_MAX_DEVICES by design,
and this work guards any cases in which id more than UIO_MAX_DEVICES is utilized.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
+++ b/drivers/uio/uio.c	2011-03-27 15:05:26.000000000 +0800
@@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_devi
 			retval = -ENOMEM;
 		goto exit;
 	}
-	idev->minor = id & MAX_ID_MASK;
+	if (id < UIO_MAX_DEVICES)
+		idev->minor = id;
+	else {
+		printk(KERN_ERR "uio: too many uio devices\n");
+		retval = -EINVAL;
+		idr_remove(&uio_idr, id);
+	}
 exit:
 	mutex_unlock(&minor_lock);
 	return retval;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
