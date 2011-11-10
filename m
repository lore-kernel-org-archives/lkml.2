Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab1KJSmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:42:40 -0500
Received: from www17.your-server.de ([213.133.104.17]:42661 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429Ab1KJSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:42:38 -0500
Message-ID: <1320950553.20155.109.camel@localhost.localdomain>
Subject: [PATCH] drivers/memstick: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 Nov 2011 19:42:33 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c 2011-11-07 19:39:05.517796746 +0100
+++ b/drivers/memstick/core/mspro_block.c 2011-11-08 10:52:46.510979781 +0100
@@ -1034,12 +1034,11 @@ static int mspro_block_read_attributes(s
 	}
 	msb->attr_group.name = "media_attributes";
 
-	buffer = kmalloc(attr_len, GFP_KERNEL);
+	buffer = kmemdup((char *)attr, attr_len, GFP_KERNEL);
 	if (!buffer) {
 		rc = -ENOMEM;
 		goto out_free_attr;
 	}
-	memcpy(buffer, (char *)attr, attr_len);
 
 	for (cnt = 0; cnt < attr_count; ++cnt) {
 		s_attr = kzalloc(sizeof(struct mspro_sys_attr), GFP_KERNEL);


