Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab1KHTi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:38:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:45103 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1KHTiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:38:55 -0500
Subject: [PATCH] staging: rtl8192e: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:37:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320781030.8062.154.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kmemdup rather than duplicating its implementation

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/memdup.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
--- a/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-07 19:38:11.780313813 +0100
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c 2011-11-08 10:51:51.523576009 +0100
@@ -3207,11 +3207,11 @@ static int rtllib_wpa_set_wpa_ie(struct
 		return -EINVAL;
 
 	if (param->u.wpa_ie.len) {
-		buf = kmalloc(param->u.wpa_ie.len, GFP_KERNEL);
+		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
+			      GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
 
-		memcpy(buf, param->u.wpa_ie.data, param->u.wpa_ie.len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = param->u.wpa_ie.len;


