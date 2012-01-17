Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab2AQHSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 02:18:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53337 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2AQHSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 02:18:42 -0500
Message-ID: <1326784710.16397.1.camel@phoenix>
Subject: [PATCH] gpio: Add missing spin_lock_init in gpio-ml-ioh driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Feng Tang <feng.tang@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Date: Tue, 17 Jan 2012 15:18:30 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this bug was introduced by commit 54be5663
"gpio-ml-ioh: Support interrupt function" which adds a spinlock to struct
ioh_gpio but never init the spinlock.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-ml-ioh.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 461958f..271fd49 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -448,6 +448,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 		chip->reg = chip->base;
 		chip->ch = i;
 		mutex_init(&chip->lock);
+		spin_lock_init(&chip->spinlock);
 		ioh_gpio_setup(chip, num_ports[i]);
 		ret = gpiochip_add(&chip->gpio);
 		if (ret) {
-- 
1.7.5.4



