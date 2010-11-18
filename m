Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823Ab0KRWJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:09:08 -0500
Received: from smtp-out-249.synserver.de ([212.40.180.249]:1054 "HELO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756649Ab0KRWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:09:05 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23983
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] POWER: gpio-chager: Provide default name for the power_supply
Date: Thu, 18 Nov 2010 23:08:39 +0100
Message-Id: <1290118119-16468-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1290118119-16468-1-git-send-email-lars@metafoo.de>
References: <1290118119-16468-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets a default name for the power_supply in case there was no name
supplied through the platform_data.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/gpio-charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index 016d5c0..27b8520 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -94,7 +94,7 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 
 	charger = &gpio_charger->charger;
 
-	charger->name = pdata->name;
+	charger->name = pdata->name ?: "gpio-charger";
 	charger->type = pdata->type;
 	charger->properties = gpio_charger_properties;
 	charger->num_properties = ARRAY_SIZE(gpio_charger_properties);
-- 
1.5.6.5

