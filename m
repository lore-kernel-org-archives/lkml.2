Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0GCQDu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:03:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55486 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0GCQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:03:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YFTObhIVgOzn/HO8JkFNTQ7d3ZzA+ZF6//BtHMBThx2P2nW9SFWRpa/BOOy6gc0GQK
         4KPNVsXtfe9EmaKNQl0TWn1tYlONPCljq8D7gAf0MzqX/Z+2rv/RIUndMnBBtTzt8iZy
         TQauwm+Rm92hlOVpFy5/h9Ut8zUj1tnOTFR4k=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Tejun Heo <tj@kernel.org>, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] arch/mn10300/unit-asb2305: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:43 +0400
Message-Id: <1278173024-11507-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/mn10300/unit-asb2305/pci-irq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/unit-asb2305/pci-irq.c b/arch/mn10300/unit-asb2305/pci-irq.c
index 91212ea..77439da 100644
--- a/arch/mn10300/unit-asb2305/pci-irq.c
+++ b/arch/mn10300/unit-asb2305/pci-irq.c
@@ -29,7 +29,7 @@ void __init pcibios_fixup_irqs(void)
 	struct pci_dev *dev = NULL;
 	u8 line, pin;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 		if (pin) {
 			dev->irq = XIRQ1;
-- 
1.7.0.4

