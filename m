Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0LMU5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 15:57:17 -0500
Received: from mail.perches.com ([173.55.12.10]:2561 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095Ab0LMU5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 15:57:16 -0500
Subject: [PATCH V3 -next] cs5535: fix printk format warnings
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D06852B.8030409@oracle.com>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	 <20101213114421.3abe0dcb.randy.dunlap@oracle.com>
	 <1292272085.26970.50.camel@Joe-Laptop>  <4D06852B.8030409@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 12:57:14 -0800
Message-ID: <1292273834.26970.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use vsprintf extension %pR to format resource.

Original-patch-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Joe Perches <joe@perches.com>

---

V3 - Might as well do both files, thanks Randy...

Removed Andres Salomon <dilinger@collabora.co.uk> from cc.
It seems that he's not there anymore.

 drivers/gpio/cs5535-gpio.c  |    3 +--
 drivers/misc/cs5535-mfgpt.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index b566fd5e..d7da7a1 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -266,8 +266,7 @@ static int __devinit cs5535_gpio_probe(struct platform_device *pdev)
 	cs5535_gpio_chip.pdev = pdev;
 	spin_lock_init(&cs5535_gpio_chip.lock);
 
-	dev_info(&pdev->dev, "region 0x%x - 0x%x reserved\n",
-			res->start, res->end);
+	dev_info(&pdev->dev, "reserved resource region %pR\n", res);
 
 	/* mask out reserved pins */
 	mask &= 0x1F7FFFFF;
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 2669306..e90506b 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -317,8 +317,7 @@ static int __devinit cs5535_mfgpt_probe(struct platform_device *pdev)
 	cs5535_mfgpt_chip.pdev = pdev;
 	spin_lock_init(&cs5535_mfgpt_chip.lock);
 
-	dev_info(&pdev->dev, "region 0x%x - 0x%x reserved\n", res->start,
-			res->end);
+	dev_info(&pdev->dev, "reserved resource region %pR\n", res);
 
 	/* detect the available timers */
 	t = scan_timers(&cs5535_mfgpt_chip);


