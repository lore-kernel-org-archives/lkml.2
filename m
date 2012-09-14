Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab2INVL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:11:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2INVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:11:24 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Russell King <linux@arm.linux.org.uk>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ARM: pci: Keep pci_common_init() around after init
Date: Fri, 14 Sep 2012 23:11:17 +0200
Message-Id: <1347657078-32230-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
References: <1347657078-32230-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:3TTDdCh81rXSl0ULxXVNV8ZuQz5IkDCCOKcoE9dFqhm
 h2IifN6BKi/PDYrRsGTz5cxA/hAxHDe7oEOB4Im9Qzq9PYc78I
 hj2znS+AyZaV8+zvCoHYPgaKc+jyYGEjPBJsFGLfkcbWj5drSA
 4JD1aptO3D1pEtEOzmF2vsnTwTbVPMWqzwiTlabO3odRCs+GpP
 Qr42nhqUvaH7RQQV0wcSYac2W8L/cL6eOv/MbGUKNvqGayGa+D
 9MgrS2QFmUSUtMkjWzzuH4f1o+Fv7ZoeHGNbZbRVnB9E23Cxe8
 KaRhkcFbJs+7rrQYOiFGvmwNkze+2NdZ4pQMXn/QLrA7h1y7Pt
 QjaWHxeI36r/RyGlfojj+b/qycrCuIjrcN0vNo2V7LyLXEjNo7
 rjRsKMtH2oETkRftxV5nX1SB8WlIvHXWSjfB0ijW3fWZ+KtEBa
 hxwJn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using deferred driver probing, PCI host controller drivers may
actually require this function after the init stage.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/kernel/bios32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index 2b2f25e..7288093 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -423,7 +423,7 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return irq;
 }
 
-static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
+static void __devinit pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 {
 	struct pci_sys_data *sys = NULL;
 	int ret;
@@ -472,7 +472,7 @@ static void __init pcibios_init_hw(struct hw_pci *hw, struct list_head *head)
 	}
 }
 
-void __init pci_common_init(struct hw_pci *hw)
+void __devinit pci_common_init(struct hw_pci *hw)
 {
 	struct pci_sys_data *sys;
 	LIST_HEAD(head);
-- 
1.7.12

