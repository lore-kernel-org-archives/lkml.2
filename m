Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab1KHTcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:32:18 -0500
Received: from www17.your-server.de ([213.133.104.17]:56021 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1KHTcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:32:17 -0500
Subject: [PATCH] staging: rtl8192e: Use kmemdup rather than duplicating its
 implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, wlanfae@realtek.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:30:20 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320780630.8062.150.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
--- a/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-07 19:38:11.783647197 +0100
+++ b/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-08 10:51:57.493656037 +0100
@@ -846,10 +846,9 @@ int rtllib_wx_set_gen_ie(struct rtllib_d
 
 			ieee->wps_ie_len = (len < MAX_WZC_IE_LEN) ? (len) :
 					   (MAX_WZC_IE_LEN);
-			buf = kmalloc(ieee->wps_ie_len, GFP_KERNEL);
+			buf = kmemdup(ie, ieee->wps_ie_len, GFP_KERNEL);
 			if (buf == NULL)
 				return -ENOMEM;
-			memcpy(buf, ie, ieee->wps_ie_len);
 			ieee->wps_ie = buf;
 			return 0;
 		}
@@ -860,10 +859,9 @@ int rtllib_wx_set_gen_ie(struct rtllib_d
 	if (len) {
 		if (len != ie[1]+2)
 			return -EINVAL;
-		buf = kmalloc(len, GFP_KERNEL);
+		buf = kmemdup(ie, len, GFP_KERNEL);
 		if (buf == NULL)
 			return -ENOMEM;
-		memcpy(buf, ie, len);
 		kfree(ieee->wpa_ie);
 		ieee->wpa_ie = buf;
 		ieee->wpa_ie_len = len;


