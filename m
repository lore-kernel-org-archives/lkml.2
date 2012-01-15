Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab2AOJ6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 04:58:38 -0500
Received: from relay03.digicable.hu ([92.249.128.185]:57052 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2AOJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 04:58:37 -0500
Message-ID: <4F12A30E.7080808@freemail.hu>
Date: Sun, 15 Jan 2012 10:57:34 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] gpio-ml-ioh: cleanup __iomem annotation usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 188.143.94.24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The __iomem annotation is to be used together with pointers used
in iowrite32() but not for pointers returned by kzalloc().
For more details see [1] and [2].

This patch will remove the following sparse warning (i.e. when
copiling with "make C=1"):
 * warning: incorrect type in assignment (different address spaces)

References:
[1] A new I/O memory access mechanism (Sep 15, 2004)
    http://lwn.net/Articles/102232/

[2] Being more anal about iospace accesses (Sep 15, 2004)
    http://lwn.net/Articles/102240/

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/gpio/gpio-ml-ioh.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 461958f..25da40a 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -248,7 +248,7 @@ static void ioh_gpio_setup(struct ioh_gpio *chip, int num_port)
 static int ioh_irq_type(struct irq_data *d, unsigned int type)
 {
 	u32 im;
-	u32 *im_reg;
+	void __iomem *im_reg;
 	u32 ien;
 	u32 im_pos;
 	int ch;
@@ -412,7 +412,7 @@ static int __devinit ioh_gpio_probe(struct pci_dev *pdev,
 	int i, j;
 	struct ioh_gpio *chip;
 	void __iomem *base;
-	void __iomem *chip_save;
+	void *chip_save;
 	int irq_base;

 	ret = pci_enable_device(pdev);
@@ -521,7 +521,7 @@ static void __devexit ioh_gpio_remove(struct pci_dev *pdev)
 	int err;
 	int i;
 	struct ioh_gpio *chip = pci_get_drvdata(pdev);
-	void __iomem *chip_save;
+	void *chip_save;

 	chip_save = chip;

-- 
1.7.2.5

