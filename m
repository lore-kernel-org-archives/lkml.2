Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab1KRJ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:56 -0500
Received: from www17.your-server.de ([213.133.104.17]:48445 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab1KRJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:27 -0500
Subject: [PATCH] [media] drxd: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.283.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
--- a/drivers/media/dvb/frontends/drxd_hard.c 2011-11-07 19:37:48.623295422 +0100
+++ b/drivers/media/dvb/frontends/drxd_hard.c 2011-11-08 10:48:49.317800208 +0100
@@ -914,14 +914,13 @@ static int load_firmware(struct drxd_sta
 		return -EIO;
 	}
 
-	state->microcode = kmalloc(fw->size, GFP_KERNEL);
+	state->microcode = kmemdup(fw->data, fw->size, GFP_KERNEL);
 	if (state->microcode == NULL) {
 		release_firmware(fw);
 		printk(KERN_ERR "drxd: firmware load failure: no memory\n");
 		return -ENOMEM;
 	}
 
-	memcpy(state->microcode, fw->data, fw->size);
 	state->microcode_length = fw->size;
 	release_firmware(fw);
 	return 0;
