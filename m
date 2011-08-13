Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1HMOL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 10:11:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:56324 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1HMOLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 10:11:48 -0400
Subject: [PATCH] staging: ft1000: dont cast void* from kmalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:31:48 +0200
Message-ID: <1313227908.16820.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Casting (void *) value returned by kmalloc is useless
 as mentioned in Documentation/CodingStyle, Chap 14.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/drop_kmalloc_cast.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c 2011-07-26 00:46:09.646838687 +0200
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c 2011-08-01 19:56:17.237666237 +0200
@@ -485,7 +485,7 @@ void card_send_command(struct ft1000_dev
 
 	DEBUG("card_send_command: enter card_send_command... size=%d\n", size);
 
-	commandbuf = (unsigned char *)kmalloc(size + 2, GFP_KERNEL);
+	commandbuf = kmalloc(size + 2, GFP_KERNEL);
 	memcpy((void *)commandbuf + 2, (void *)ptempbuffer, size);
 
 	ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);


