Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437Ab1LJM7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:59:40 -0500
Received: from www17.your-server.de ([213.133.104.17]:42474 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1LJM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:59:35 -0500
Subject: [PATCH] [media] uvcvideo: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: laurent.pinchart@ideasonboard.com, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.315.camel@localhost.localdomain>
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

diff -u -p a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
--- a/drivers/media/video/uvc/uvc_ctrl.c 2011-11-28 19:36:47.613437745 +0100
+++ b/drivers/media/video/uvc/uvc_ctrl.c 2011-11-28 19:58:26.309317018 +0100
@@ -1861,7 +1861,7 @@ int uvc_ctrl_init_device(struct uvc_devi
 		if (ncontrols == 0)
 			continue;
 
-		entity->controls = kzalloc(ncontrols * sizeof(*ctrl),
+		entity->controls = kcalloc(ncontrols, sizeof(*ctrl),
 					   GFP_KERNEL);
 		if (entity->controls == NULL)
 			return -ENOMEM;
