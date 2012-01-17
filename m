Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2AQIkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:40:49 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35254 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2AQIks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:40:48 -0500
Message-ID: <1326789637.7383.1.camel@phoenix>
Subject: [PATCH] gpio: Add missing spin_lock_init in gpio-pch driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Tue, 17 Jan 2012 16:40:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was introduced by commit d568a681
"gpio-pch: add spinlock in suspend/resume processing"
which adds a spinlock to struct pch_gpio but never init the spinlock.

Reported-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-pch.c b/drivers/gpio/gpio-pch.c
index f060329..e84eabf 100644
--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -392,6 +392,7 @@ static int __devinit pch_gpio_probe(struct pci_dev *pdev,
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
 	mutex_init(&chip->lock);
+	spin_lock_init(&chip->spinlock);
 	pch_gpio_setup(chip);
 	ret = gpiochip_add(&chip->gpio);
 	if (ret) {
-- 
1.7.5.4



