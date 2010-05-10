Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0EJB1X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 21:27:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64374 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab0EJB1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 21:27:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Vl5wF9Ow6np2tZzS9MZRDBREw52mn+yjXWvOk2BlhJIXhGNa9DlzHKVSz36sO3SxGS
         0tjc4U/fukkl5c8VNFbLG0WoWOvbzq5BFVBxafhTEJeMctZhanbo6Kc1+D8c11HIiyeC
         r6zjuqs+5JzlmQZ5igxzDke+k8wTY4I1ddwAM=
Subject: [PATCH] max8925_bl: properly unregisters a backlight device object
	in error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
       Samuel Ortiz <sameo@linux.intel.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Content-Type: text/plain
Date: Mon, 10 May 2010 09:27:34 +0800
Message-Id: <1273454854.6536.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly unregisters a previously registered backlight device object in error handling of max8925_backlight_probe.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/max8925_bl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index b5accc9..b2b2c7b 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -162,6 +162,7 @@ static int __devinit max8925_backlight_probe(struct platform_device *pdev)
 	backlight_update_status(bl);
 	return 0;
 out:
+	backlight_device_unregister(bl);
 	kfree(data);
 	return ret;
 }
-- 
1.5.4.3



