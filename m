Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2IFP1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:27:39 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62900 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667Ab2IFPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:24:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] drivers/media/i2c/mt9m032.c: fix error return code
Date: Thu,  6 Sep 2012 17:23:51 +0200
Message-Id: <1346945041-26676-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/i2c/mt9m032.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 445359c..f80c1d7 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -781,7 +781,7 @@ static int mt9m032_probe(struct i2c_client *client,
 	ret = mt9m032_write(client, MT9M032_RESET, 1);	/* reset on */
 	if (ret < 0)
 		goto error_entity;
-	mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
+	ret = mt9m032_write(client, MT9M032_RESET, 0);	/* reset off */
 	if (ret < 0)
 		goto error_entity;
 

