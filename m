Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1LJM7z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:59:55 -0500
Received: from www17.your-server.de ([213.133.104.17]:42511 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1LJM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:59:51 -0500
Subject: [PATCH] [media] xc4000: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.312.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
--- a/drivers/media/common/tuners/tuner-xc2028.c 2011-11-13 11:07:28.453519914 +0100
+++ b/drivers/media/common/tuners/tuner-xc2028.c 2011-11-28 19:57:19.631625147 +0100
@@ -311,7 +311,7 @@ static int load_all_firmwares(struct dvb
 		   n_array, fname, name,
 		   priv->firm_version >> 8, priv->firm_version & 0xff);
 
-	priv->firm = kzalloc(sizeof(*priv->firm) * n_array, GFP_KERNEL);
+	priv->firm = kcalloc(n_array, sizeof(*priv->firm), GFP_KERNEL);
 	if (priv->firm == NULL) {
 		tuner_err("Not enough memory to load firmware file.\n");
 		rc = -ENOMEM;
diff -u -p a/drivers/media/common/tuners/xc4000.c b/drivers/media/common/tuners/xc4000.c
--- a/drivers/media/common/tuners/xc4000.c 2011-11-13 11:07:28.460186686 +0100
+++ b/drivers/media/common/tuners/xc4000.c 2011-11-28 19:57:16.224893821 +0100
@@ -758,7 +758,7 @@ static int xc4000_fwupload(struct dvb_fr
 		n_array, fname, name,
 		priv->firm_version >> 8, priv->firm_version & 0xff);
 
-	priv->firm = kzalloc(sizeof(*priv->firm) * n_array, GFP_KERNEL);
+	priv->firm = kcalloc(n_array, sizeof(*priv->firm), GFP_KERNEL);
 	if (priv->firm == NULL) {
 		printk(KERN_ERR "Not enough memory to load firmware file.\n");
 		rc = -ENOMEM;
