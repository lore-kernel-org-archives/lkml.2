Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2HDSMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 14:12:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2HDSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 14:12:28 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 2/2] staging: media: cxd2099: use kzalloc to allocate ci pointer of type struct cxd in cxd2099_attach
Date: Sat,  4 Aug 2012 23:57:21 +0545
Message-Id: <1344103941-23047-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this does kmalloc and followed by memset, calling kzalloc will actually
sets the allocated memory to zero, use kzalloc instead

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 1678503..4f2235f 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -691,10 +691,9 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 		return NULL;
 	}
 
-	ci = kmalloc(sizeof(struct cxd), GFP_KERNEL);
+	ci = kzalloc(sizeof(struct cxd), GFP_KERNEL);
 	if (!ci)
 		return NULL;
-	memset(ci, 0, sizeof(*ci));
 
 	mutex_init(&ci->lock);
 	memcpy(&ci->cfg, cfg, sizeof(struct cxd2099_cfg));
-- 
1.7.9.5

