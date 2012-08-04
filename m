Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab2HDSMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:12:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2HDSMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:12:12 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/2] staging: media: cxd2099: fix sparse warnings in cxd2099_attach
Date: Sat,  4 Aug 2012 23:57:03 +0545
Message-Id: <1344103923-22616-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following sparse warnings were fixed

drivers/staging/media/cxd2099/cxd2099.c:686:26: warning: Using plain integer as NULL pointer
drivers/staging/media/cxd2099/cxd2099.c:691:24: warning: Using plain integer as NULL pointer
drivers/staging/media/cxd2099/cxd2099.c:696:24: warning: Using plain integer as NULL pointer

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 1c04185..1678503 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -683,17 +683,17 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 				      void *priv,
 				      struct i2c_adapter *i2c)
 {
-	struct cxd *ci = 0;
+	struct cxd *ci;
 	u8 val;
 
 	if (i2c_read_reg(i2c, cfg->adr, 0, &val) < 0) {
 		printk(KERN_INFO "No CXD2099 detected at %02x\n", cfg->adr);
-		return 0;
+		return NULL;
 	}
 
 	ci = kmalloc(sizeof(struct cxd), GFP_KERNEL);
 	if (!ci)
-		return 0;
+		return NULL;
 	memset(ci, 0, sizeof(*ci));
 
 	mutex_init(&ci->lock);
-- 
1.7.9.5

