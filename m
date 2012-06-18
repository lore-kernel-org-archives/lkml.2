Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab2FRJ2n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:28:43 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:53678 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972Ab2FRJ2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:28:42 -0400
From: Roland Stigge <stigge@antcom.de>
To: ralf@linux-mips.org, blogic@openwrt.org, jkosina@suse.cz,
        standby24x7@gmail.com, bhelgaas@google.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] mips: pci-lantiq: Fix check for valid gpio
Date: Mon, 18 Jun 2012 11:28:26 +0200
Message-Id: <1340011706-32281-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two checks for valid gpio number, formerly (wrongly)
considering zero as invalid, now using gpio_is_valid().

Signed-off-by: Roland Stigge <stigge@antcom.de>
---
 arch/mips/pci/pci-lantiq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/arch/mips/pci/pci-lantiq.c
+++ linux-2.6/arch/mips/pci/pci-lantiq.c
@@ -129,7 +129,7 @@ static int __devinit ltq_pci_startup(str
 
 	/* setup reset gpio used by pci */
 	reset_gpio = of_get_named_gpio(node, "gpio-reset", 0);
-	if (reset_gpio > 0)
+	if (gpio_is_valid(reset_gpio))
 		devm_gpio_request(&pdev->dev, reset_gpio, "pci-reset");
 
 	/* enable auto-switching between PCI and EBU */
@@ -192,7 +192,7 @@ static int __devinit ltq_pci_startup(str
 	ltq_ebu_w32(ltq_ebu_r32(LTQ_EBU_PCC_IEN) | 0x10, LTQ_EBU_PCC_IEN);
 
 	/* toggle reset pin */
-	if (reset_gpio > 0) {
+	if (gpio_is_valid(reset_gpio)) {
 		__gpio_set_value(reset_gpio, 0);
 		wmb();
 		mdelay(1);
