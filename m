Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1LJM75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:59:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:42508 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1LJM7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:59:50 -0500
Subject: [PATCH] [media] v4l2-ctrls: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: g.liakhovetski@gmx.de, mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.316.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
--- a/drivers/media/video/stk-webcam.c 2011-11-13 11:07:31.543568623 +0100
+++ b/drivers/media/video/stk-webcam.c 2011-11-28 19:58:06.822415120 +0100
@@ -377,8 +377,8 @@ static int stk_prepare_iso(struct stk_ca
 	if (dev->isobufs)
 		STK_ERROR("isobufs already allocated. Bad\n");
 	else
-		dev->isobufs = kzalloc(MAX_ISO_BUFS * sizeof(*dev->isobufs),
-					GFP_KERNEL);
+		dev->isobufs = kcalloc(MAX_ISO_BUFS, sizeof(*dev->isobufs),
+				       GFP_KERNEL);
 	if (dev->isobufs == NULL) {
 		STK_ERROR("Unable to allocate iso buffers\n");
 		return -ENOMEM;
diff -u -p a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
--- a/drivers/media/video/v4l2-ctrls.c 2011-11-28 19:36:47.613437745 +0100
+++ b/drivers/media/video/v4l2-ctrls.c 2011-11-28 19:58:10.342457254 +0100
@@ -1108,8 +1108,8 @@ int v4l2_ctrl_handler_init(struct v4l2_c
 	INIT_LIST_HEAD(&hdl->ctrls);
 	INIT_LIST_HEAD(&hdl->ctrl_refs);
 	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
-	hdl->buckets = kzalloc(sizeof(hdl->buckets[0]) * hdl->nr_of_buckets,
-								GFP_KERNEL);
+	hdl->buckets = kcalloc(hdl->nr_of_buckets, sizeof(hdl->buckets[0]),
+			       GFP_KERNEL);
 	hdl->error = hdl->buckets ? 0 : -ENOMEM;
 	return hdl->error;
 }
