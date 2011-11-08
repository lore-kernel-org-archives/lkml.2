Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab1KHTVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:21:32 -0500
Received: from www17.your-server.de ([213.133.104.17]:42668 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab1KHTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:21:31 -0500
Subject: [PATCH] staging: rtl8192e: Use kzalloc rather than kmalloc
From: Thomas Meyer <thomas@m3y3r.de>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, wlanfae@realtek.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Nov 2011 20:19:40 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1320779985.8062.148.camel@localhost.localdomain>
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

diff -u -p a/drivers/staging/rtl8192e/rtllib_crypt.c b/drivers/staging/rtl8192e/rtllib_crypt.c
--- a/drivers/staging/rtl8192e/rtllib_crypt.c 2011-11-07 19:38:11.773647045 +0100
+++ b/drivers/staging/rtl8192e/rtllib_crypt.c 2011-11-08 09:40:09.789244618 +0100
@@ -104,11 +104,10 @@ int rtllib_register_crypto_ops(struct rt
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -202,11 +201,10 @@ int __init rtllib_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 


