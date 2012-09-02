Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2IBVi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:38:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36805 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab2IBViY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:38:24 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] PCI: drop duplicate const in DECLARE_PCI_FIXUP_SECTION
Date: Sun,  2 Sep 2012 23:37:24 +0200
Message-Id: <1346621844-31211-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's redundant and makes sparse complain about it.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 include/linux/pci.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..aee24a8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1472,7 +1472,7 @@ enum pci_fixup_pass {
 /* Anonymous variables would be nice... */
 #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,	\
 				  class_shift, hook)			\
-	static const struct pci_fixup const __pci_fixup_##name __used	\
+	static const struct pci_fixup __pci_fixup_##name __used		\
 	__attribute__((__section__(#section), aligned((sizeof(void *)))))    \
 		= { vendor, device, class, class_shift, hook };
 
-- 
1.7.10.4

