Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab2LDFHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 00:07:38 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47768 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2LDFHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 00:07:36 -0500
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 00:01:03 -0500
Message-ID: <CAPgLHd9-y2gde+4mfP0orZkhuCaJ+JEOQqZVkvAesqKkPmow0A@mail.gmail.com>
Subject: [PATCH -next] mn10300: use for_each_pci_dev to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dhowells@redhat.com, yasutake.koichi@jp.panasonic.com
Cc: yongjun_wei@trendmicro.com.cn, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_pci_dev to simplify the code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/mn10300/unit-asb2305/pci-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


