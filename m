Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab1BMECW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 23:02:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33016 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab1BMECQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 23:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=t6XkigPoZQInp2AEauZqrfZNLGJDmi0NGUS1jJYZnHAyn1z2FRApTJOWcc0w7kfURw
         phkTHcCnGU+sJzKPdx26HjGwNnrYBTGpd64SjpnAGBKUF0T2ZgwnyoGgjuyJEIxxlkhH
         JoXiQnXg+orHnVf9rg8E2MYBo1rdWHn6JCo/8=
Subject: [PATCH] video: metronomefb: add __devexit_p around reference to
 metronomefb_remove
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-fbdev@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 12:02:10 +0800
Message-ID: <1297569730.3608.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

metronomefb_remove is marked __devexit,
thus add __devexit_p around reference to metronomefb_remove.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/metronomefb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/metronomefb.c b/drivers/video/metronomefb.c
index 63ed3b7..ed64edf 100644
--- a/drivers/video/metronomefb.c
+++ b/drivers/video/metronomefb.c
@@ -765,7 +765,7 @@ static int __devexit metronomefb_remove(struct platform_device *dev)
 
 static struct platform_driver metronomefb_driver = {
 	.probe	= metronomefb_probe,
-	.remove = metronomefb_remove,
+	.remove = __devexit_p(metronomefb_remove),
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "metronomefb",
-- 
1.7.1



