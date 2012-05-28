Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab2E1UVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 16:21:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33478 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2E1UVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 16:21:11 -0400
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH] 8250_pci: Remove duplicate struct pciserial_board
Date: Mon, 28 May 2012 15:20:47 -0500
Message-Id: <1338236447-4047-1-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pbn_exsys_4055 is the same thing as pbn_b2_4_115200 so replace it with
the standard pattern.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/tty/serial/8250/8250_pci.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 28e7c7c..66e5909 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1887,7 +1887,6 @@ enum pci_board_num_t {
 	pbn_panacom,
 	pbn_panacom2,
 	pbn_panacom4,
-	pbn_exsys_4055,
 	pbn_plx_romulus,
 	pbn_oxsemi,
 	pbn_oxsemi_1_4000000,
@@ -2393,13 +2392,6 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.reg_shift	= 7,
 	},
 
-	[pbn_exsys_4055] = {
-		.flags		= FL_BASE2,
-		.num_ports	= 4,
-		.base_baud	= 115200,
-		.uart_offset	= 8,
-	},
-
 	/* I think this entry is broken - the first_offset looks wrong --rmk */
 	[pbn_plx_romulus] = {
 		.flags		= FL_BASE2,
@@ -3193,7 +3185,7 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
 		PCI_SUBVENDOR_ID_EXSYS,
 		PCI_SUBDEVICE_ID_EXSYS_4055, 0, 0,
-		pbn_exsys_4055 },
+		pbn_b2_4_115200 },
 	/*
 	 * Megawolf Romulus PCI Serial Card, from Mike Hudson
 	 * (Exoray@isys.ca)
-- 
1.7.10.2

