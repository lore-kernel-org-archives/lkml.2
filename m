Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2DRVYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 17:24:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:41466 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2DRVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 17:24:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] pci: frv architecture needs generic setup-bus infrastructure
Date: Wed, 18 Apr 2012 17:24:14 -0400
Message-Id: <1334784254-17603-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we get this link failure for frv's defconfig:

   LD      .tmp_vmlinux1
 drivers/built-in.o: In function `pci_assign_resource':
 (.text+0xbf0c): undefined reference to `pci_cardbus_resource_alignment'
 drivers/built-in.o: In function `pci_setup':
 pci.c:(.init.text+0x174): undefined reference to `pci_realloc_get_opt'
 pci.c:(.init.text+0x1a0): undefined reference to `pci_realloc_get_opt'
 make[1]: *** [.tmp_vmlinux1] Error 1

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 083a49f..165274c 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -42,6 +42,7 @@ obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PARISC) += setup-bus.o
 obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
 obj-$(CONFIG_PPC) += setup-bus.o
+obj-$(CONFIG_FRV) += setup-bus.o
 obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
 obj-$(CONFIG_X86_VISWS) += setup-irq.o
 obj-$(CONFIG_MN10300) += setup-bus.o
-- 
1.7.9.1

