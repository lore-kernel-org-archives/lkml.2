Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808Ab2KHUZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:25:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43459 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2KHUYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:50 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: integrator: use BUG_ON where possible
Date: Thu,  8 Nov 2012 15:23:08 -0500
Message-Id: <1352406191-14303-6-git-send-email-sasha.levin@oracle.com>
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
 arch/arm/mach-integrator/pci_v3.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index bbeca59..85938de 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -191,12 +191,9 @@ static void __iomem *v3_open_config_window(struct pci_bus *bus,
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
 
 	if (busnr == 0) {
 		int slot = PCI_SLOT(devfn);
-- 
1.7.10.4

