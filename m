Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1JEIBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:01:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40672 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab1JEIBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:01:45 -0400
Subject: [PATCH] video: platinumfb: Add __devexit_p at necessary place
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 16:01:38 +0800
Message-ID: <1317801698.12133.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the comments in include/linux/init.h:

"Pointers to __devexit functions must use __devexit_p(function_name), the
wrapper will insert either the function_name or NULL, depending on the config
options."

We have __devexit annotation for platinumfb_remove(), thus add __devexit_p at
necessary place.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/platinumfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/platinumfb.c b/drivers/video/platinumfb.c
index 6694923..ae3caa6 100644
--- a/drivers/video/platinumfb.c
+++ b/drivers/video/platinumfb.c
@@ -683,7 +683,7 @@ static struct platform_driver platinum_driver =
 		.of_match_table = platinumfb_match,
 	},
 	.probe		= platinumfb_probe,
-	.remove		= platinumfb_remove,
+	.remove		= __devexit_p(platinumfb_remove),
 };
 
 static int __init platinumfb_init(void)
-- 
1.7.4.1



