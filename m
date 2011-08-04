Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab1HDKaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:30:22 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59174 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab1HDK3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:29:44 -0400
From: Julia Lawall <julia@diku.dk>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: kernel-janitors@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/leds/leds-pca9532.c: delete useless initialization
Date: Thu,  4 Aug 2011 12:29:34 +0200
Message-Id: <1312453774-23333-5-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312453774-23333-1-git-send-email-julia@diku.dk>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete nontrivial initialization that is immediately overwritten by the
result of an allocation function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
identifier i;
expression e;
@@

(
T i = \(0\|NULL\|ERR_PTR(...)\);
|
-T i = e;
+T i;
)
... when != i
i = \(kzalloc\|kcalloc\|kmalloc\)(...);

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/leds/leds-pca9532.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -447,7 +447,7 @@ exit:
 static int pca9532_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
-	struct pca9532_data *data = i2c_get_clientdata(client);
+	struct pca9532_data *data;
 	struct pca9532_platform_data *pca9532_pdata = client->dev.platform_data;
 	int err;
 

