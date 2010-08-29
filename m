Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0H2KxT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 06:53:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab0H2KxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 06:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ucR0L6DmVjQjsBu0Qjwm4tQ+Rk1ru5MSmYi6Y6jiSgKrOMYuZRHqwjv5z89hOHyXn8
         6lJR+fjrXUIpO3eFgBCsIbZ/oBma0vr9L3WdcgGMCEaIyBR2wsw4UkEZRQ+3ijlgUjYf
         ZVjwgDwYwdsRKhdGF68RSe0YRa48RTJVW2vQo=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: wim@iguana.be
Cc: linux-kernel@vger.kernel.org, mika.westerberg@iki.fi
Subject: [PATCH] watchdog: ts72xx_wdt: disable watchdog at probe
Date: Sun, 29 Aug 2010 13:53:14 +0300
Message-Id: <1283079194-20156-1-git-send-email-mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it may be already enabled by bootloader or some other utility. This patch
makes sure that the watchdog is disabled before any userspace daemon opens the
device. It is also required by the watchdog API.

Signed-off-by: Mika Westerberg <mika.westerberg@iki.fi>
---
 drivers/watchdog/ts72xx_wdt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 458c499..18cdeb4 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -449,6 +449,9 @@ static __devinit int ts72xx_wdt_probe(struct platform_device *pdev)
 	wdt->pdev = pdev;
 	mutex_init(&wdt->lock);
 
+	/* make sure that the watchdog is disabled */
+	ts72xx_wdt_stop(wdt);
+
 	error = misc_register(&ts72xx_wdt_miscdev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register miscdev\n");
-- 
1.5.6.5

