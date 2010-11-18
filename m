Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771Ab0KRWJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:09:07 -0500
Received: from smtp-out-249.synserver.de ([212.40.180.249]:1051 "HELO
	smtp-out-247.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756222Ab0KRWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:09:05 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23983
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] POWER: gpio-charger: Check result of kzalloc
Date: Thu, 18 Nov 2010 23:08:37 +0100
Message-Id: <1290118119-16468-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kzalloc can return NULL we have to check its result.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/power/gpio-charger.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index fccbe99..8458caf 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -87,6 +87,10 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (!gpio_charger) {
+		dev_err(&pdev->dev, "Failed to alloc driver structure\n");
+		return -ENOMEM;
+	}
 
 	charger = &gpio_charger->charger;
 
-- 
1.5.6.5

