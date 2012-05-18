Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab2ERDFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 23:05:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40475 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762584Ab2ERCwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:34 -0400
Message-Id: <20120518023258.578495439@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 31/53] gpio: Add missing spin_lock_init in gpio-ml-ioh driver
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 7e3a70fb7bccada029c188c89bfbf3c0a63c1500 upstream.

This bug was introduced by commit 54be5663
"gpio-ml-ioh: Support interrupt function" which adds a spinlock to struct
ioh_gpio but never init the spinlock.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpio/gpio-ml-ioh.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 03d6dd5..f0febe5 100644
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
1.7.10



