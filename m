Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1HFItK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 04:49:10 -0400
Received: from www17.your-server.de ([213.133.104.17]:59315 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab1HFItG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 04:49:06 -0400
Subject: [PATCH] [media] davinci vpbe: Use resource_size()
From: Thomas Meyer <thomas@m3y3r.de>
To: mchehab@infradead.org, linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 06 Aug 2011 10:48:32 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312620517.5589.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

 Use resource_size function on resource object
 instead of explicit computation.

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/resource_size.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/davinci/vpbe_osd.c b/drivers/media/video/davinci/vpbe_osd.c
--- a/drivers/media/video/davinci/vpbe_osd.c 2011-07-30 11:10:29.138430171 +0200
+++ b/drivers/media/video/davinci/vpbe_osd.c 2011-08-01 22:50:30.997700024 +0200
@@ -1162,7 +1162,7 @@ static int osd_probe(struct platform_dev
 		goto free_mem;
 	}
 	osd->osd_base_phys = res->start;
-	osd->osd_size = res->end - res->start + 1;
+	osd->osd_size = resource_size(res);
 	if (!request_mem_region(osd->osd_base_phys, osd->osd_size,
 				MODULE_NAME)) {
 		dev_err(osd->dev, "Unable to reserve OSD MMIO region\n");


