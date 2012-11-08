Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2KHUZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:25:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45384 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab2KHUY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:59 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khc@pm.waw.pl>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: versatile: use BUG_ON where possible
Date: Thu,  8 Nov 2012 15:23:11 -0500
Message-Id: <1352406191-14303-9-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use BUG_ON() instead of constructions such as:

	if (...)
		BUG()

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) BUG();
+ BUG_ON(e);
// </smpl>

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 arch/arm/mach-versatile/pci.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 2f84f40..3936a11 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -82,12 +82,9 @@ static void __iomem *__pci_addr(struct pci_bus *bus,
 	/*
 	 * Trap out illegal values
 	 */
-	if (offset > 255)
-		BUG();
-	if (busnr > 255)
-		BUG();
-	if (devfn > 255)
-		BUG();
+	BUG_ON(offset > 255);
+	BUG_ON(busnr > 255);
+	BUG_ON(devfn > 255);
 
 	return VERSATILE_PCI_CFG_VIRT_BASE + ((busnr << 16) |
 		(PCI_SLOT(devfn) << 11) | (PCI_FUNC(devfn) << 8) | offset);
-- 
1.7.10.4

