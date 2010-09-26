Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0IZJBD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 05:01:03 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59317 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab0IZI7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RgM0YwbnI7NuUXSkAQSku2yx1Ll1RrcTW/eXzdVFHUAUoRVuM4RHyR3KOgv+8EtNfW
         uZ/nPu5hzxh+QG6jO4T1OwXY7GvT0JrGp2arjuU8VoQc+I1leSem5p3I15EMP2xvk4Ll
         QEIElFxMw/xXYWBLG7LcqnyTidQ4kWqAA3jOo=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Cyril Chemparathy <cyril@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] keyboard: tnetv107x: fix input_device leak
Date: Sun, 26 Sep 2010 12:59:44 +0400
Message-Id: <1285491584-32664-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keypad_probe() calls input_free_device() on error, but keypad_remove()
doesn't.
---
 Compile tested.

 drivers/input/keyboard/tnetv107x-keypad.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/tnetv107x-keypad.c b/drivers/input/keyboard/tnetv107x-keypad.c
index b4a81eb..1ea20e1 100644
--- a/drivers/input/keyboard/tnetv107x-keypad.c
+++ b/drivers/input/keyboard/tnetv107x-keypad.c
@@ -305,6 +305,7 @@ static int __devexit keypad_remove(struct platform_device *pdev)
 	free_irq(kp->irq_press, kp);
 	free_irq(kp->irq_release, kp);
 	input_unregister_device(kp->input_dev);
+	input_free_device(kp->input_dev);
 	clk_put(kp->clk);
 	iounmap(kp->regs);
 	release_mem_region(kp->res->start, resource_size(kp->res));
-- 
1.7.0.4

