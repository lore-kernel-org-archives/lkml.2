Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab1GURQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:16:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34612 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab1GURQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:16:30 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] eisa/pci_eisa.c: fix section mismatch
Date: Thu, 21 Jul 2011 13:16:18 -0400
Message-Id: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: vmlinux.o(.data+0x15d3ac): Section mismatch in reference from the variable pci_eisa_driver to the function .init.text:pci_eisa_init()
The variable pci_eisa_driver references the function __init pci_eisa_init()
If the reference is valid then annotate the variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Cc: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 drivers/eisa/pci_eisa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index 0dd0f63..30da70d 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -45,13 +45,13 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 	return 0;
 }
 
-static struct pci_device_id pci_eisa_pci_tbl[] = {
+static struct pci_device_id __initdata pci_eisa_pci_tbl[] = {
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
 	{ 0, }
 };
 
-static struct pci_driver pci_eisa_driver = {
+static struct pci_driver __initdata pci_eisa_driver = {
 	.name		= "pci_eisa",
 	.id_table	= pci_eisa_pci_tbl,
 	.probe		= pci_eisa_init,
-- 
1.7.6.153.g78432

