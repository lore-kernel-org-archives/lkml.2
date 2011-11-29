Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735Ab1LERda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:33:30 -0500
Received: from www17.your-server.de ([213.133.104.17]:38044 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab1LERa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:30:56 -0500
Subject: [PATCH] [media] pvrusb2: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: isely@pobox.com, mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.313.camel@localhost.localdomain>
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

diff -u -p a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c 2011-11-13 11:07:30.836890817 +0100
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c 2011-11-28 19:57:31.228511987 +0100
@@ -2546,8 +2546,9 @@ struct pvr2_hdw *pvr2_hdw_create(struct
 	}
 
 	/* Define and configure additional controls from cx2341x module. */
-	hdw->mpeg_ctrl_info = kzalloc(
-		sizeof(*(hdw->mpeg_ctrl_info)) * MPEGDEF_COUNT, GFP_KERNEL);
+	hdw->mpeg_ctrl_info = kcalloc(MPEGDEF_COUNT,
+				      sizeof(*(hdw->mpeg_ctrl_info)),
+				      GFP_KERNEL);
 	if (!hdw->mpeg_ctrl_info) goto fail;
 	for (idx = 0; idx < MPEGDEF_COUNT; idx++) {
 		cptr = hdw->controls + idx + CTRLDEF_COUNT;
