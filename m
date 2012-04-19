Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab2DSVRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:17:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38471 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965175Ab2DSVRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:25 -0400
Message-Id: <20120419210822.828308816@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 49/68] gpio: Add missing spin_lock_init in gpio-pch driver
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit d166370ad86b33b1111af3a0cdd7de94e03789a6 upstream.

This bug was introduced by commit d568a681
"gpio-pch: add spinlock in suspend/resume processing"
which adds a spinlock to struct pch_gpio but never init the spinlock.

Reported-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpio/gpio-pch.c
+++ b/drivers/gpio/gpio-pch.c
@@ -392,6 +392,7 @@ static int __devinit pch_gpio_probe(stru
 	chip->reg = chip->base;
 	pci_set_drvdata(pdev, chip);
 	mutex_init(&chip->lock);
+	spin_lock_init(&chip->spinlock);
 	pch_gpio_setup(chip);
 	ret = gpiochip_add(&chip->gpio);
 	if (ret) {


