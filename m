Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1HLLkR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 07:40:17 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:46815 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab1HLLkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 07:40:15 -0400
From: Julia Lawall <julia@diku.dk>
To: Antoine Jacquet <royale@zerezo.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/media/video/zr364xx.c: add missing cleanup code
Date: Fri, 12 Aug 2011 13:40:08 +0200
Message-Id: <1313149208-7368-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

It seems just as necessary to free cam->vdev and cam in this error case as
in the next one.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
There is yet another block of error handling code below the call to
zr364xx_board_init, but perhaps no cleanup code is needed in that case,
because that code is currently initializing a lock in cam?

 drivers/media/video/zr364xx.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index c492846..e78cf94 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -1638,6 +1638,9 @@ static int zr364xx_probe(struct usb_interface *intf,
 
 	if (!cam->read_endpoint) {
 		dev_err(&intf->dev, "Could not find bulk-in endpoint\n");
+		video_device_release(cam->vdev);
+		kfree(cam);
+		cam = NULL;
 		return -ENOMEM;
 	}
 

