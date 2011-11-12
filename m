Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1KLQ7u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 11:59:50 -0500
Received: from www17.your-server.de ([213.133.104.17]:34374 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab1KLQ7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 11:59:34 -0500
Message-ID: <1321100317.1668.25.camel@localhost.localdomain>
Subject: [PATCH] staging: go7007: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 13:18:37 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
--- a/drivers/staging/media/go7007/go7007-driver.c 2011-11-07 19:38:11.440308651 +0100
+++ b/drivers/staging/media/go7007/go7007-driver.c 2011-11-08 10:52:05.237093171 +0100
@@ -109,14 +109,13 @@ static int go7007_load_encoder(struct go
 		return -1;
 	}
 	fw_len = fw_entry->size - 16;
-	bounce = kmalloc(fw_len, GFP_KERNEL);
+	bounce = kmemdup(fw_entry->data + 16, fw_len, GFP_KERNEL);
 	if (bounce == NULL) {
 		v4l2_err(go, "unable to allocate %d bytes for "
 				"firmware transfer\n", fw_len);
 		release_firmware(fw_entry);
 		return -1;
 	}
-	memcpy(bounce, fw_entry->data + 16, fw_len);
 	release_firmware(fw_entry);
 	if (go7007_interface_reset(go) < 0 ||
 			go7007_send_firmware(go, bounce, fw_len) < 0 ||


