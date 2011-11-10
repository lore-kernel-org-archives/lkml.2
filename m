Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1KJS1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:27:51 -0500
Received: from www17.your-server.de ([213.133.104.17]:43197 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab1KJS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:27:47 -0500
Message-ID: <1320949662.20155.103.camel@localhost.localdomain>
Subject: [PATCH] USB: Realtek cr: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Date: Thu, 10 Nov 2011 19:27:42 +0100
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

diff -u -p a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
--- a/drivers/usb/storage/realtek_cr.c 2011-11-07 19:38:15.850375635 +0100
+++ b/drivers/usb/storage/realtek_cr.c 2011-11-08 10:56:26.333926507 +0100
@@ -398,10 +398,9 @@ static int rts51x_write_mem(struct us_da
 	u8 cmnd[12] = { 0 };
 	u8 *buf;
 
-	buf = kmalloc(len, GFP_NOIO);
+	buf = kmemdup(data, len, GFP_NOIO);
 	if (buf == NULL)
 		return USB_STOR_TRANSPORT_ERROR;
-	memcpy(buf, data, len);
 
 	US_DEBUGP("%s, addr = 0x%x, len = %d\n", __func__, addr, len);
 


