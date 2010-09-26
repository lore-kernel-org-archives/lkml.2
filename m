Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab0IZMPS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 08:15:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46854 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab0IZMPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 08:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=w9zhPiPGAzXj8Ne9hAi37GUXoxXviDem6AB1++ty/fN9/3eE0GmOSxcJTY64XUuYTv
         JoVWz+SlmaH9tn8S7dewDyDSjEgLzezCnPyjhcTT/Jrn+i/QTwKlycYAHrvpOsdQlXeJ
         uzF/fCZoPoxlG541lFXqkdWCHcWwHn1QtId1U=
From: Rahul Ruikar <rahul.ruikar@gmail.com>
To: dmitry.torokhov@gmail.com, nm127@freemail.hu
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Subject: [PATCH] input: gameport: emu10k1-gp: call pci_disable_device in error path and in remove()
Date: Sun, 26 Sep 2010 17:44:45 +0530
Message-Id: <1285503285-6219-1-git-send-email-rahul.ruikar@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_disable_device() is called for following 2 cases
- error path in emu_probe()
- in emu_remove()

Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
---
 drivers/input/gameport/emu10k1-gp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/gameport/emu10k1-gp.c b/drivers/input/gameport/emu10k1-gp.c
index 7392992..34615d4 100644
--- a/drivers/input/gameport/emu10k1-gp.c
+++ b/drivers/input/gameport/emu10k1-gp.c
@@ -77,6 +77,7 @@ static int __devinit emu_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (!emu || !port) {
 		printk(KERN_ERR "emu10k1-gp: Memory allocation failed\n");
 		release_region(ioport, iolen);
+		pci_disable_device(pdev);
 		kfree(emu);
 		gameport_free_port(port);
 		return -ENOMEM;
@@ -105,6 +106,7 @@ static void __devexit emu_remove(struct pci_dev *pdev)
 
 	gameport_unregister_port(emu->gameport);
 	release_region(emu->io, emu->size);
+	pci_disable_device(pdev);
 	kfree(emu);
 }
 
-- 
1.7.2.3

