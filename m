Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2HAMkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:40:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35984 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2HAMkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:40:43 -0400
Message-ID: <1343824834.3859.2.camel@phoenix>
Subject: [PATCH RFT] leds: lp8788: Fix updating scale configuration bits
From: Axel Lin <axel.lin@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Richard Purdie <rpurdie@rpsys.net>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 01 Aug 2012 20:40:34 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to do left shift (cfg->num + LP8788_ISINK_SCALE_OFFSET) bits for
updating scale configuration.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Milo,
Current code of updating scale configuration bits looks wrong to me
because the mask does not match the val.
I don't have this hardware, can you test this patch?

Thanks,
Axel
 drivers/leds/leds-lp8788.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/leds-lp8788.c b/drivers/leds/leds-lp8788.c
index 53bd136..0ade6eb 100644
--- a/drivers/leds/leds-lp8788.c
+++ b/drivers/leds/leds-lp8788.c
@@ -63,7 +63,7 @@ static int lp8788_led_init_device(struct lp8788_led *led,
 	/* scale configuration */
 	addr = LP8788_ISINK_CTRL;
 	mask = 1 << (cfg->num + LP8788_ISINK_SCALE_OFFSET);
-	val = cfg->scale << cfg->num;
+	val = cfg->scale << (cfg->num + LP8788_ISINK_SCALE_OFFSET);
 	ret = lp8788_update_bits(led->lp, addr, mask, val);
 	if (ret)
 		return ret;
-- 
1.7.9.5



