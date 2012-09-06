Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2IFPYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:24:14 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35860 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2IFPYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:12 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/14] drivers/media/usb/hdpvr/hdpvr-core.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:48 +0200
Message-Id: <1346945041-26676-1-git-send-email-peter.senna@gmail.com>
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
 drivers/media/usb/hdpvr/hdpvr-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 304f43e..84dc26f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -401,12 +401,14 @@ static int hdpvr_probe(struct usb_interface *interface,
 	client = hdpvr_register_ir_rx_i2c(dev);
 	if (!client) {
 		v4l2_err(&dev->v4l2_dev, "i2c IR RX device register failed\n");
+		retval = -ENODEV;
 		goto reg_fail;
 	}
 
 	client = hdpvr_register_ir_tx_i2c(dev);
 	if (!client) {
 		v4l2_err(&dev->v4l2_dev, "i2c IR TX device register failed\n");
+		retval = -ENODEV;
 		goto reg_fail;
 	}
 #endif

