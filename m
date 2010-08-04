Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0HDBnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:43:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51553 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab0HDBne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iSdFzg3HMeDbfAQgr6JD78SnyMANw1kJrEo3ci/xTVdhLcw02gunwQU9frCPkLN/uV
         3EJpOZ/wAcYfKHgAf+j8ij3K6KdMJ+624ImCDMh+8ZyAUYafkh+A8DDNux+tuzYsI77R
         D6BB/ws020S612dV4lLNOjQlcbkyx7EVsxSzs=
Subject: [PATCH] wm8994-core: fix wm8994_device_init() return value
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Wed, 04 Aug 2010 09:44:47 +0800
Message-Id: <1280886287.31990.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm8994_device_init() will return 0 in the case of kzalloc fail
in current implementation.
This patch fixes the return value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8994-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index ec71c93..69533f5 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -326,8 +326,10 @@ static int wm8994_device_init(struct wm8994 *wm8994, unsigned long id, int irq)
 	wm8994->supplies = kzalloc(sizeof(struct regulator_bulk_data) *
 				   ARRAY_SIZE(wm8994_main_supplies),
 				   GFP_KERNEL);
-	if (!wm8994->supplies)
+	if (!wm8994->supplies) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
 		wm8994->supplies[i].supply = wm8994_main_supplies[i];
-- 
1.5.4.3



