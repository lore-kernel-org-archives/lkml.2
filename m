Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2BJLee (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:34:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61269 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757920Ab2BJLed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:34:33 -0500
Message-ID: <1328873668.4203.3.camel@phoenix>
Subject: [PATCH] drivers/leds/leds-pca9633.c: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Meerwald <p.meerwald@bct-electronic.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 10 Feb 2012 19:34:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/leds/leds-pca9633.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pca9633.c b/drivers/leds/leds-pca9633.c
index c408ddc..80cb61a 100644
--- a/drivers/leds/leds-pca9633.c
+++ b/drivers/leds/leds-pca9633.c
@@ -110,7 +110,7 @@ static int __devinit pca9633_probe(struct i2c_client *client,
 		}
 	}
 
-	pca9633 = kcalloc(sizeof(*pca9633), 4, GFP_KERNEL);
+	pca9633 = kcalloc(4, sizeof(*pca9633), GFP_KERNEL);
 	if (!pca9633)
 		return -ENOMEM;
 
-- 
1.7.5.4



