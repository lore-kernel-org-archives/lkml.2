Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178Ab1KHTTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:19:48 -0500
Received: from www17.your-server.de ([213.133.104.17]:58014 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1KHTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:19:47 -0500
Subject: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, wlanfae@realtek.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:17:53 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320779880.8062.146.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c
--- a/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt_ccmp.c 2011-11-08 09:40:09.422573035 +0100
@@ -63,10 +63,9 @@ static void *rtllib_ccmp_init(int key_id
 {
 	struct rtllib_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);


