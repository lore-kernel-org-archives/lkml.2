Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2IFP1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:27:10 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62287 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2IFPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/14] drivers/media/radio/radio-cadet.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:52 +0200
Message-Id: <1346945041-26676-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/radio/radio-cadet.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 697a421..643d80a 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -645,7 +645,8 @@ static int __init cadet_init(void)
 	set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);
 	video_set_drvdata(&dev->vdev, dev);
 
-	if (video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr) < 0)
+	res = video_register_device(&dev->vdev, VFL_TYPE_RADIO, radio_nr);
+	if (res < 0)
 		goto err_hdl;
 	v4l2_info(v4l2_dev, "ADS Cadet Radio Card at 0x%x\n", dev->io);
 	return 0;

