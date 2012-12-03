Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab2LCN2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 08:28:38 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47141 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2LCN2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 08:28:37 -0500
MIME-Version: 1.0
Date: Mon, 3 Dec 2012 08:28:36 -0500
Message-ID: <CAPgLHd-GK0ZO97vhaNhFuHBxuHf+s+7YQ1kw_-+7pUVoqNwgdw@mail.gmail.com>
Subject: [PATCH -next] tile/PCI: use for_each_pci_dev to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: cmetcalf@tilera.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use for_each_pci_dev to simplify the code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/tile/kernel/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/tile/kernel/pci.c b/arch/tile/kernel/pci.c
index 7598226..aac1cd5 100644
--- a/arch/tile/kernel/pci.c
+++ b/arch/tile/kernel/pci.c
@@ -245,7 +245,7 @@ static void __devinit fixup_read_and_payload_sizes(void)
 	u16 new_values;
 
 	/* Scan for the smallest maximum payload size. */
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		u32 devcap;
 		int max_payload;
 
@@ -260,7 +260,7 @@ static void __devinit fixup_read_and_payload_sizes(void)
 
 	/* Now, set the max_payload_size for all devices to that value. */
 	new_values = (max_read_size << 12) | (smallest_max_payload << 5);
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
+	for_each_pci_dev(dev)
 		pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 				PCI_EXP_DEVCTL_PAYLOAD | PCI_EXP_DEVCTL_READRQ,
 				new_values);


