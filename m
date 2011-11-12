Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab1KLJWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 04:22:44 -0500
Received: from www17.your-server.de ([213.133.104.17]:47991 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab1KLJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 04:22:42 -0500
Message-ID: <1321089754.20155.128.camel@localhost.localdomain>
Subject: [PATCH] cifs: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 12 Nov 2011 10:22:34 +0100
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

diff -u -p a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
--- a/fs/cifs/cifs_spnego.c 2011-11-07 19:38:22.023802738 +0100
+++ b/fs/cifs/cifs_spnego.c 2011-11-08 10:34:14.586074433 +0100
@@ -37,12 +37,11 @@ cifs_spnego_key_instantiate(struct key *
 	int ret;
 
 	ret = -ENOMEM;
-	payload = kmalloc(datalen, GFP_KERNEL);
+	payload = kmemdup(data, datalen, GFP_KERNEL);
 	if (!payload)
 		goto error;
 
 	/* attach the data */
-	memcpy(payload, data, datalen);
 	key->payload.data = payload;
 	ret = 0;
 


