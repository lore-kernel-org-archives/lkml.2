Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0GCQE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0GCQES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ppbWAJ95mfNNj8/gTK00eeG/oKsYpc26oS/7YMxvuIPyrNwjmOP/xkq+UbDMkIJzQm
         OGYIARhyRqpcitBcGYKxqCOXYySKqXS2N6WVagpJvedctt4a1JG2XVgGIY3pi3OdCAb9
         a+9k+QA48n3ItLrV99C2LCfMh+IjuOk8THAdM=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/19] drivers/net/irda: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:15 +0400
Message-Id: <1278173056-11779-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/net/irda/smsc-ircc2.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index d67e484..850ca1c 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -2848,9 +2848,7 @@ static int __init smsc_ircc_preconfigure_subsystems(unsigned short ircc_cfg,
 	unsigned short ss_device = 0x0000;
 	int ret = 0;
 
-	dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-
-	while (dev != NULL) {
+	for_each_pci_dev(dev) {
 		struct smsc_ircc_subsystem_configuration *conf;
 
 		/*
@@ -2899,7 +2897,6 @@ static int __init smsc_ircc_preconfigure_subsystems(unsigned short ircc_cfg,
 					ret = -ENODEV;
 			}
 		}
-		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
 	}
 
 	return ret;
-- 
1.7.0.4

