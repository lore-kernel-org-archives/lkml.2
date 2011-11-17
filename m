Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1KRJ2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:28:43 -0500
Received: from www17.your-server.de ([213.133.104.17]:48440 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067Ab1KRJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:26 -0500
Subject: [PATCH] [media] dw2102: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.282.camel@localhost.localdomain>
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

diff -u -p a/drivers/media/dvb/dvb-usb/dw2102.c b/drivers/media/dvb/dvb-usb/dw2102.c
--- a/drivers/media/dvb/dvb-usb/dw2102.c 2011-11-07 19:37:48.086620605 +0100
+++ b/drivers/media/dvb/dvb-usb/dw2102.c 2011-11-08 10:48:56.977902892 +0100
@@ -1859,12 +1859,11 @@ static struct dvb_usb_device_properties
 static int dw2102_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
-	p1100 = kzalloc(sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
+	p1100 = kmemdup(&s6x0_properties,
+			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
 	if (!p1100)
 		return -ENOMEM;
 	/* copy default structure */
-	memcpy(p1100, &s6x0_properties,
-			sizeof(struct dvb_usb_device_properties));
 	/* fill only different fields */
 	p1100->firmware = "dvb-usb-p1100.fw";
 	p1100->devices[0] = d1100;
@@ -1872,13 +1871,12 @@ static int dw2102_probe(struct usb_inter
 	p1100->rc.legacy.rc_map_size = ARRAY_SIZE(rc_map_tbs_table);
 	p1100->adapter->fe[0].frontend_attach = stv0288_frontend_attach;
 
-	s660 = kzalloc(sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
+	s660 = kmemdup(&s6x0_properties,
+		       sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
 	if (!s660) {
 		kfree(p1100);
 		return -ENOMEM;
 	}
-	memcpy(s660, &s6x0_properties,
-			sizeof(struct dvb_usb_device_properties));
 	s660->firmware = "dvb-usb-s660.fw";
 	s660->num_device_descs = 3;
 	s660->devices[0] = d660;
@@ -1886,14 +1884,13 @@ static int dw2102_probe(struct usb_inter
 	s660->devices[2] = d480_2;
 	s660->adapter->fe[0].frontend_attach = ds3000_frontend_attach;
 
-	p7500 = kzalloc(sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
+	p7500 = kmemdup(&s6x0_properties,
+			sizeof(struct dvb_usb_device_properties), GFP_KERNEL);
 	if (!p7500) {
 		kfree(p1100);
 		kfree(s660);
 		return -ENOMEM;
 	}
-	memcpy(p7500, &s6x0_properties,
-			sizeof(struct dvb_usb_device_properties));
 	p7500->firmware = "dvb-usb-p7500.fw";
 	p7500->devices[0] = d7500;
 	p7500->rc.legacy.rc_map_table = rc_map_tbs_table;
