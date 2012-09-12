Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2ILV1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:27:33 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:53401 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2ILV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:27:30 -0400
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] input: gpio_keys_polled: fix dt pdata->nbuttons
Date: Wed, 12 Sep 2012 18:27:23 -0300
Message-Id: <1347485243-21173-1-git-send-email-aletes.xgr@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata->nbuttons should be updated by the dt code.

Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
---
 drivers/input/keyboard/gpio_keys_polled.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
index 7908952..f2142de 100644
--- a/drivers/input/keyboard/gpio_keys_polled.c
+++ b/drivers/input/keyboard/gpio_keys_polled.c
@@ -129,6 +129,7 @@ gpio_keys_polled_get_devtree_pdata(struct device *dev)
 	}
 
 	pdata->buttons = (struct gpio_keys_button *)(pdata + 1);
+	pdata->nbuttons = nbuttons;
 
 	pdata->rep = !!of_get_property(node, "autorepeat", NULL);
 	of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
-- 
1.7.10

