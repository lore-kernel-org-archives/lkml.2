Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab0HXKq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:46:58 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52683 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0HXKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:46:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ZRpAb933HqmeS/KHV02zvY/xTJ/gyYRiRG5gWuK3hfIIO/SbefWfmnRS+c1ogD1914
         YRghw2jYbZNKJD+fdvhX8M7IteVQie3ps5l/JiNU1r+OQCTDyCZ94gBXxGRd7p6x/zDV
         yGPIxnAKT2ry4gAor2aAe4LKHgaz7tCPxIYLU=
Subject: [PATCH] Input: pxa27x_keypad - remove input_free_device() in
 pxa27x_keypad_remove()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 18:47:20 +0800
Message-ID: <1282646840.2567.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to call input_free_device() after input_unregister_device().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/input/keyboard/pxa27x_keypad.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index 0e53b3b..f32404f 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -567,8 +567,6 @@ static int __devexit pxa27x_keypad_remove(struct platform_device *pdev)
 	clk_put(keypad->clk);
 
 	input_unregister_device(keypad->input_dev);
-	input_free_device(keypad->input_dev);
-
 	iounmap(keypad->mmio_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.0.4



