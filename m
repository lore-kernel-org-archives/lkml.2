Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab1LJM7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:59:37 -0500
Received: from www17.your-server.de ([213.133.104.17]:42472 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1LJM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:59:35 -0500
Subject: [PATCH] [media] v4l: s5p-tv: Use kcalloc instead of kzalloc to
 allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: kyungmin.park@samsung.com, t.stanislaws@samsung.com, mchehab@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.314.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
--- a/drivers/media/video/s5p-tv/hdmi_drv.c 2011-11-13 11:07:31.380232715 +0100
+++ b/drivers/media/video/s5p-tv/hdmi_drv.c 2011-11-28 19:58:21.305922829 +0100
@@ -838,8 +838,8 @@ static int hdmi_resources_init(struct hd
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
 	}
-	res->regul_bulk = kzalloc(ARRAY_SIZE(supply) *
-		sizeof res->regul_bulk[0], GFP_KERNEL);
+	res->regul_bulk = kcalloc(ARRAY_SIZE(supply),
+				  sizeof(res->regul_bulk[0]), GFP_KERNEL);
 	if (!res->regul_bulk) {
 		dev_err(dev, "failed to get memory for regulators\n");
 		goto fail;
