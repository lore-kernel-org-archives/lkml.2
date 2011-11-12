Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab1KLJ2C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 04:28:02 -0500
Received: from www17.your-server.de ([213.133.104.17]:48302 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1KLJ2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 04:28:00 -0500
Message-ID: <1321090072.20155.130.camel@localhost.localdomain>
Subject: [PATCH] ecryptfs: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: ecryptfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 12 Nov 2011 10:27:52 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/ecryptfs/messaging.c b/fs/ecryptfs/messaging.c
--- a/fs/ecryptfs/messaging.c 2011-11-07 19:38:22.340474214 +0100
+++ b/fs/ecryptfs/messaging.c 2011-11-08 10:34:54.896614796 +0100
@@ -350,14 +350,13 @@ int ecryptfs_process_response(struct ecr
 		goto unlock;
 	}
 	msg_size = (sizeof(*msg) + msg->data_len);
-	msg_ctx->msg = kmalloc(msg_size, GFP_KERNEL);
+	msg_ctx->msg = kmemdup(msg, msg_size, GFP_KERNEL);
 	if (!msg_ctx->msg) {
 		rc = -ENOMEM;
 		printk(KERN_ERR "%s: Failed to allocate [%zd] bytes of "
 		       "GFP_KERNEL memory\n", __func__, msg_size);
 		goto unlock;
 	}
-	memcpy(msg_ctx->msg, msg, msg_size);
 	msg_ctx->state = ECRYPTFS_MSG_CTX_STATE_DONE;
 	rc = 0;
 wake_up:


