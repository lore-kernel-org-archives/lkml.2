Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2KFV4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:56:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51167 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab2KFVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:55:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [PATCH 7/8] ata: highbank: mark ahci_highbank_probe as __devinit
Date: Tue,  6 Nov 2012 22:55:32 +0100
Message-Id: <1352238933-4886-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1352238933-4886-1-git-send-email-arnd@arndb.de>
References: <1352238933-4886-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oQM2Nb2FpM/JP98YNZes+7+tFTmvDAK4Kp4rqTWvbVz
 3tzEGZ/3na6oWULIi7eF4uMgzx/KcaA9HfJr6JH7n/ebximoR9
 pXjvzl2dwITAP17F0gtm3UYJZ45Y0c7lxasAemaghzgaZpK3Pb
 RBvEHUR7KKCcGPFfXn53b0KiRHWu06Ezfa8h/LwOB6iWkZJCot
 JbnM8A5BQ91fxpt9gNR2vGI2jRsNzJV598T0onCd1v1r1ptPuw
 ABJDf1PXLnQwqC1FkuSY6CfMYV35pAWRavv/H53Vg8KRRlPc0r
 QQUArWWZiR/ZvJi8IuEr2FcY3q8AkGyBkmGH2u2Xa0sdlFC6Xb
 8M7KTsmQmzZ7OLZ+bt7muaGrECH0A/wD7BrDJnuorLOGnDVXo1
 oHVAEjgH06aGQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ahci_highbank_probe function is incorrectly marked as __init,
which means it can get discarded at boot time, which might be
a problem if for some reason the device only becomes operational
after loading another module.

Using __devinit instead avoids seeing this warning for every build:

WARNING: vmlinux.o(.data+0xf7b0): Section mismatch in reference from the
variable ahci_highbank_driver to the function .init.text:ahci_highbank_probe()
The variable ahci_highbank_driver references
the function __init ahci_highbank_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

