Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab1BMNGg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 08:06:36 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64539 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1BMNG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 08:06:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=U2SOSo62MrHhxDMQjGAKC1UwIokcmcUjmey8/aMUXBGf+Fl4uk2O46KnzWeWwocxGw
         iBw38ly3gVOkO2sfg4aiMYD1B/awvvEWCWj743BYswWcBXW8HHKdy1infH4yHCt1zFEA
         2dZlhATnQdFjq3V1vskw5rzcrm0tRxYAEH6fo=
Subject: [PATCH] video: hecubafb: add __devexit_p around reference to
 hecubafb_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 21:06:23 +0800
Message-ID: <1297602383.2433.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hecubafb_remove is marked __devexit,
thus add __devexit_p around reference to hecubafb_remove.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/hecubafb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index c77bcc6..1b94643 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -299,7 +299,7 @@ static int __devexit hecubafb_remove(struct platform_device *dev)
 
 static struct platform_driver hecubafb_driver = {
 	.probe	= hecubafb_probe,
-	.remove = hecubafb_remove,
+	.remove = __devexit_p(hecubafb_remove),
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "hecubafb",
-- 
1.7.1



