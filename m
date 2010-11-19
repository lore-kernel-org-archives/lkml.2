Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0KSSmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 13:42:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:32907 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab0KSSmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 13:42:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=X/D/yjhaFtlAxx5kybW5wqBg6QTtVXmzdF6sTSpflXZe7WKkBWhA1DDGQAkm60pZv4
         zggjQ2tXne+kl5Fxxfxt642S5ueQxHH0IzX0DubvS94rYokiI/W37OVQMjvb8hRYmmxd
         1RTTWmxj20YgqPoUwRZqHUoYCvvcedTV+IHvs=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] power: gpio-charger: fix potential NULL dereference
Date: Fri, 19 Nov 2010 21:41:54 +0300
Message-Id: <1290192114-11659-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() result is not compared with NULL.  It might lead to NULL
pointer dereference in OOM situation.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/power/gpio-charger.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index fccbe99..b07a71c 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -87,6 +87,10 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (!gpio_charger) {
+		dev_err(&pdev->dev, "kzalloc failed\n");
+		return -ENOMEM;
+	}
 
 	charger = &gpio_charger->charger;
 
-- 
1.7.0.4

