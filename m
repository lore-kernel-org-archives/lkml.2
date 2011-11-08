Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1KHTQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:16:06 -0500
Received: from www17.your-server.de ([213.133.104.17]:57701 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab1KHTQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:16:05 -0500
Subject: [PATCH] HID: hid-lg4ff: Casting (void *) value returned by kmalloc
 is useless
From: Thomas Meyer <thomas@m3y3r.de>
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:14:14 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320779660.8062.141.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
--- a/drivers/hid/hid-lg4ff.c 2011-11-07 19:37:44.816570939 +0100
+++ b/drivers/hid/hid-lg4ff.c 2011-11-08 09:03:29.394045138 +0100
@@ -430,7 +430,7 @@ int lg4ff_init(struct hid_device *hid)
 	}
 
 	/* Add the device to device_list */
-	entry = (struct lg4ff_device_entry *)kzalloc(sizeof(struct lg4ff_device_entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(struct lg4ff_device_entry), GFP_KERNEL);
 	if (!entry) {
 		hid_err(hid, "Cannot add device, insufficient memory.\n");
 		return -ENOMEM;


