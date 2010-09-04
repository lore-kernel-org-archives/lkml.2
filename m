Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab0IDMYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:24:47 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:33365 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0IDMYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:24:46 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 1/1] MEDIA: ere_ir, fix NULL dereference
Date: Sat,  4 Sep 2010 14:24:31 +0200
Message-Id: <1283603071-13471-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When 'dev' allocation fails in ene_probe we jump to error label where
we dereference the 'dev'. Fix it by jumping few lines below.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/IR/ene_ir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/IR/ene_ir.c b/drivers/media/IR/ene_ir.c
index 5447750..b475030 100644
--- a/drivers/media/IR/ene_ir.c
+++ b/drivers/media/IR/ene_ir.c
@@ -785,7 +785,7 @@ static int ene_probe(struct pnp_dev *pnp_dev, const struct pnp_device_id *id)
 	dev = kzalloc(sizeof(struct ene_device), GFP_KERNEL);
 
 	if (!input_dev || !ir_props || !dev)
-		goto error;
+		goto error1;
 
 	/* validate resources */
 	error = -ENODEV;
@@ -899,7 +899,7 @@ error:
 		free_irq(dev->irq, dev);
 	if (dev->hw_io)
 		release_region(dev->hw_io, ENE_MAX_IO);
-
+error1:
 	input_free_device(input_dev);
 	kfree(ir_props);
 	kfree(dev);
-- 
1.7.2.2


