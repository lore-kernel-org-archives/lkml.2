Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0LBMpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 07:45:49 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49731 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab0LBMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 07:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=r12YXofPKR1s7nkjHQRr+DlmekTYDqJGv/lCK9qLM2WSmC3fM0WCmW7dmzlJaFXik3
         u6XFYQ/Y4btAYnRhUN35/OsCcJH1U7vqfGAW5bBjD5RjpzG8T6G6SelVO7R1w9MjZ6HP
         EDgbYRwSOKadZvuyTrasG1SJmKjiyBAwoboIU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net
Subject: [PATCH 2/2] atm: lanai: use kernel's '%pM' format option to print MAC
Date: Thu,  2 Dec 2010 14:45:08 +0200
Message-Id: <1291293908-29180-2-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1291293908-29180-1-git-send-email-andy.shevchenko@gmail.com>
References: <1291293908-29180-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
---
 drivers/atm/lanai.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index cbe15a8..930051d 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -2241,11 +2241,8 @@ static int __devinit lanai_dev_open(struct atm_dev *atmdev)
 	memcpy(atmdev->esi, eeprom_mac(lanai), ESI_LEN);
 	lanai_timed_poll_start(lanai);
 	printk(KERN_NOTICE DEV_LABEL "(itf %d): rev.%d, base=0x%lx, irq=%u "
-	    "(%02X-%02X-%02X-%02X-%02X-%02X)\n", lanai->number,
-	    (int) lanai->pci->revision, (unsigned long) lanai->base,
-	    lanai->pci->irq,
-	    atmdev->esi[0], atmdev->esi[1], atmdev->esi[2],
-	    atmdev->esi[3], atmdev->esi[4], atmdev->esi[5]);
+		"(%pMF)\n", lanai->number, (int) lanai->pci->revision,
+		(unsigned long) lanai->base, lanai->pci->irq, atmdev->esi);
 	printk(KERN_NOTICE DEV_LABEL "(itf %d): LANAI%s, serialno=%u(0x%X), "
 	    "board_rev=%d\n", lanai->number,
 	    lanai->type==lanai2 ? "2" : "HB", (unsigned int) lanai->serialno,
-- 
1.7.2.3

