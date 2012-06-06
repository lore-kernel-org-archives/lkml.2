Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab2FFVmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:42:53 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:33775 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758736Ab2FFVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:41:55 -0400
X-IronPort-AV: E=Sophos;i="4.75,726,1330902000"; 
   d="scan'208";a="161655288"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Brett Rudley <brudley@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com,
        Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/7] drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c: adjust suspicious bit operation
Date: Wed,  6 Jun 2012 23:41:39 +0200
Message-Id: <1339018901-28439-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1339018901-28439-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

IRQF_TRIGGER_HIGH is 0x00000004, so it seems that & was intended rather than |.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index e2480d1..bed208f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -91,7 +91,7 @@ int brcmf_sdio_intr_register(struct brcmf_sdio_dev *sdiodev)
 
 	/* redirect, configure ane enable io for interrupt signal */
 	data = SDIO_SEPINT_MASK | SDIO_SEPINT_OE;
-	if (sdiodev->irq_flags | IRQF_TRIGGER_HIGH)
+	if (sdiodev->irq_flags & IRQF_TRIGGER_HIGH)
 		data |= SDIO_SEPINT_ACT_HI;
 	brcmf_sdio_regwb(sdiodev, SDIO_CCCR_BRCM_SEPINT, data, &ret);
 

