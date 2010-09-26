Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0IZI7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:59:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0IZI7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:59:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CFZcI4+aVbd6cZDGcOxZrUn+XzEIKnfjeLqmheiVvlRgkj2QSsqMp2CBJOJR8HYCSz
         87sZ4b+NMpW7IviKcipGMVU1sDz/z0/V8Su31AaZEEzaYLuSo4U4Ankj5kwIWZ3tBLCZ
         nOZ0nyhAZ/lkwwoK+dxV+c5hI6PRFqdJMKOxk=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Cyril Chemparathy <cyril@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] touchscreen: tnetv107x: fix input_device leak
Date: Sun, 26 Sep 2010 12:59:47 +0400
Message-Id: <1285491587-32707-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tsc_probe() calls input_free_device() on error, but tsc_remove()
doesn't.
---
 drivers/input/touchscreen/tnetv107x-ts.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
index cf1dba2..82d9a01 100644
--- a/drivers/input/touchscreen/tnetv107x-ts.c
+++ b/drivers/input/touchscreen/tnetv107x-ts.c
@@ -361,6 +361,7 @@ static int __devexit tsc_remove(struct platform_device *pdev)
 
 	input_unregister_device(ts->input_dev);
 	free_irq(ts->tsc_irq, ts);
+	input_free_device(ts->input_dev);
 	clk_put(ts->clk);
 	iounmap(ts->regs);
 	release_mem_region(ts->res->start, resource_size(ts->res));
-- 
1.7.0.4

