Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1GFGzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:55:51 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:32816 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1GFGzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:55:48 -0400
Subject: backlight: aat2870_bl: questions about setting max_current
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jin Park <jinyoungp@nvidia.com>, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 14:55:42 +0800
Message-ID: <1309935342.6088.5.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Jin,
Just found some questions about setting max_current in current implementation of aat2870_bl:

1. Seems the implementation tests wrong value for setting aat2870_bl->max_current.
   I think you mean:

diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index f13a3f7..a8a2545 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -175,7 +175,7 @@ static int aat2870_bl_probe(struct platform_device *pdev)
        else
                aat2870_bl->channels = AAT2870_BL_CH_ALL;
 
-       if (pdata->max_brightness > 0)
+       if (pdata->max_current > 0)
                aat2870_bl->max_current = pdata->max_current;
        else
                aat2870_bl->max_current = AAT2870_CURRENT_27_9;


2. Even above issue is fixed, you still cannot differentiate below 2 cases:
        a) if pdata->max_current is not set , or
        b) pdata->max_current is set to AAT2870_CURRENT_0_45 ( which is also 0 ).
   In either case, current implementation will set max_current to AAT2870_CURRENT_27_9.

Regards,
Axel



