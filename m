Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab1DCBlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 21:41:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36045 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1DCBlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 21:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ARcr2DWb2GzN4E8RMbVp0vuyJ4vS/NNAKXur8tD2mfry+nJWhwIg77YvLOXk3XGaG/
         XWYK04BFFGFvMZ2GKCUS16hU5r2zgpacfnNcuzZ7Hk+1qh9SFMF2B4bYZcwbXPMd2IPf
         GPf6FNxGRaw3c4hAAI4bKKsdEvWVXUEe/eGYU=
Subject: [PATCH] Input: rpckbd - fix a leak of the IRQ during init failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 03 Apr 2011 09:41:06 +0800
Message-ID: <1301794866.3657.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rpckbd_open prror path, free_irq() was using NULL rather than the
driver data as the data pointer so free_irq() wouldn't have matched.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/serio/rpckbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 9da6fbc..7ec3c97 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -90,7 +90,7 @@ static int rpckbd_open(struct serio *port)
 
 	if (request_irq(IRQ_KEYBOARDTX, rpckbd_tx, 0, "rpckbd", port) != 0) {
 		printk(KERN_ERR "rpckbd.c: Could not allocate keyboard transmit IRQ\n");
-		free_irq(IRQ_KEYBOARDRX, NULL);
+		free_irq(IRQ_KEYBOARDRX, port);
 		return -EBUSY;
 	}
 
-- 
1.7.1



