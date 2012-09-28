Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946358Ab2I1VjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:39:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423352Ab2I1VgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:36:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [PATCH 02/12] ata: mark probe function as __devinit rather than __init
Date: Fri, 28 Sep 2012 23:36:07 +0200
Message-Id: <1348868177-21205-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:piGqQJntyoEnzCUbir+vn5p77MPamPP0OvHXsZ1OVUi
 8gH82Y9XKK6WFejQbgJkm7ejeDdqJvdzgsSOb8fz6GZn3A7c2l
 mk3R+MtgmleEPw0HDR3JEELEolCpsl+jafYbnDYb+20Hev9qfl
 WFWkQMpbZbU8jrmsktcZcGO3sMULGR3sFm7s4b2xfXQApyM7Yd
 q8dIIS0pvotTFrGmZ/5fHcFHOGccV5TJz4zmpnQ+vzl86eMpHb
 FYRTmp23FBLLJgFThgQ982EFXA5eagSK94F/fvfeRIdZkNofpw
 +h3ITwg/VLiZccpSfnL1JQl3iwuanVsoxYOk4i0TDlR5EJ3R55
 FKr6T4PS7BbTNjpsN0hDajTadfPIgag3BmINsczUImPSrKQf/0
 dWE7ZoIOr+Vcw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions for hotplugging must be marked as __devinit so
they do not get discarded, as pointed out by a build time
warning from modpost.

Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/sata_highbank.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
index 0d7c4c2..36a141a 100644
--- a/drivers/ata/sata_highbank.c
+++ b/drivers/ata/sata_highbank.c
@@ -260,7 +260,7 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
-static int __init ahci_highbank_probe(struct platform_device *pdev)
+static int __devinit ahci_highbank_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
-- 
1.7.10

