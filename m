Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0KZRHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:07:03 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34294 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab0KZRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=W/9VIHnuH0kFpGLm+NUazOqIIc4N+XsRSQOZPcOZgio4d6ZsKH3332pDdTqXZS5uNL
         qlHUG/8BPfaoHobVBfBlmLL9cjtZzy290KVeUoL8OGo2KiEmMNMRItg/KyX2blTQyxBn
         fhXdTThXuJlqm1L2KFnC/RIRTHeJOiUwVazTA=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] power: gpio-charger: fix potential NULL dereference
Date: Fri, 26 Nov 2010 20:06:47 +0300
Message-Id: <1290791209-21493-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kzalloc() may fail, if so return with -ENOMEM.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/power/gpio-charger.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index fccbe99..41e4687 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -87,6 +87,8 @@ static int __devinit gpio_charger_probe(struct platform_device *pdev)
 	}
 
 	gpio_charger = kzalloc(sizeof(*gpio_charger), GFP_KERNEL);
+	if (gpio_charger == NULL)
+		return -ENOMEM;
 
 	charger = &gpio_charger->charger;
 
-- 
1.7.0.4

