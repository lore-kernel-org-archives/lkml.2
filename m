Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203Ab1KHTWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:22:09 -0500
Received: from www17.your-server.de ([213.133.104.17]:42714 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab1KHTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:22:07 -0500
Subject: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, wlanfae@realtek.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:20:14 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320780021.8062.149.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this change is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
--- a/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-07 19:38:11.783647197 +0100
+++ b/drivers/staging/rtl8192e/rtllib_wx.c 2011-11-08 09:40:14.075968748 +0100
@@ -368,11 +368,10 @@ int rtllib_wx_set_encode(struct rtllib_d
 		struct rtllib_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct rtllib_crypt_data),
+		new_crypt = kzalloc(sizeof(struct rtllib_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct rtllib_crypt_data));
 		new_crypt->ops = rtllib_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
 			request_module("rtllib_crypt_wep");


