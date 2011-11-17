Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab1KRJaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:30:08 -0500
Received: from www17.your-server.de ([213.133.104.17]:48600 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab1KRJ2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:28:40 -0500
Subject: [PATCH] [media] v4l: Casting (void *) value returned by kmalloc is
 useless
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.247.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/vino.c b/drivers/media/video/vino.c
--- a/drivers/media/video/vino.c 2011-11-07 19:37:51.673341747 +0100
+++ b/drivers/media/video/vino.c 2011-11-08 09:05:04.618617718 +0100
@@ -708,7 +708,7 @@ static int vino_allocate_buffer(struct v
 		size, count);
 
 	/* allocate memory for table with virtual (page) addresses */
-	fb->desc_table.virtual = (unsigned long *)
+	fb->desc_table.virtual =
 		kmalloc(count * sizeof(unsigned long), GFP_KERNEL);
 	if (!fb->desc_table.virtual)
 		return -ENOMEM;
