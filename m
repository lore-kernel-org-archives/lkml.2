Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab1AMIc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 03:32:27 -0500
Received: from outer.eatpbank.ru ([91.202.252.240]:59278 "EHLO
	outer.eatpbank.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab1AMIcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 03:32:09 -0500
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Jan 2011 03:32:07 EST
Content-Type: text/plain; charset=koi8-r; format=flowed; delsp=yes
Date: Thu, 13 Jan 2011 11:26:55 +0300
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, alan@linux.intel.com
Subject: JSM module patch
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: =?koi8-r?B?8MHTwdvOycvP1yDhLuEu?= <pepper@eatpbank.ru>
Organization: EATPBank
Message-ID: <op.vo8m25okgaomyf@pepper.eatpbank.ru>
User-Agent: Opera Mail/11.00 (Linux)
X-Spam_score: -2.9
X-Spam_score_int: -28
X-Spam_bar: --
X-Spam_report: Spam detection software, running on the system "outer.eatpbank.ru", has
 identified this incoming email as possible spam.  The original message
 has been attached to this so you can view it (if it isn't spam) or label
 similar future email.  If you have any questions, see
 @@CONTACT_ADDRESS@@ for details.
 Content preview:  Hello! We use the OS Debian Squeeze kernel 2.6.32-5-686. There
    is a problem: We have an internal PCI card Digi Neo 4 with device ID 114F:00B0
    (has 4 COM-ports). Core module JSM doesn't support device described above,
    but support the same device with 8 COM-port and device ID 114F:00B1. Can
   you include this patches: [...] 
 Content analysis details:   (-2.9 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
 -1.0 ALL_TRUSTED            Passed through trusted hosts only via SMTP
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

We use the OS Debian Squeeze kernel 2.6.32-5-686.
There is a problem:
We have an internal PCI card Digi Neo 4 with device ID 114F:00B0 (has 4  
COM-ports).
Core module JSM doesn't support device described above, but support the  
same device with 8 COM-port and device ID 114F:00B1.
Can you include this patches:

linux-2.6-2.6.32/include/linux/pci_ids.h
	--- pci_ids.h	2009-12-03 06:51:21.000000000 +0300
	+++ pci_ids.h	2011-01-11 14:07:32.000000000 +0300
	@@ -1460,6 +1464,7 @@
	 #define PCI_DEVICE_ID_DIGI_DF_M_E	0x0071
	 #define PCI_DEVICE_ID_DIGI_DF_M_IOM2_A	0x0072
	 #define PCI_DEVICE_ID_DIGI_DF_M_A	0x0073
	+#define PCI_DEVICE_ID_DIGI_NEO_4	0x00B0
	 #define PCI_DEVICE_ID_DIGI_NEO_8	0x00B1
	 #define PCI_DEVICE_ID_NEO_2DB9          0x00C8
	 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9

linux-source-2.6.32/drivers/serial/jsm/jsm_driver.c
	--- jsm_driver.c	2009-12-03 06:51:21.000000000 +0300
	+++ jsm_driver.c	2011-01-11 16:50:57.000000000 +0300
	@@ -81,7 +81,7 @@
  			/* store the info for the board we've found */
  			brd->boardnum = adapter_count++;
	 	brd->pci_dev = pdev;
	-	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
	+	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM || pdev->device ==  
PCI_DEVICE_ID_DIGI_NEO_4)
	 		brd->maxports = 4;
	 	else if (pdev->device == PCI_DEVICE_ID_DIGI_NEO_8)
	 		brd->maxports = 8;
	@@ -213,6 +213,7 @@
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0, 0, 3 },
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0, 0, 4 },
	 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_8), 0, 0, 5 },
	+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_NEO_4), 0, 0, 6 },
	 	{ 0, }
	 };
	 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);

to the source?

same diff`s attached.

Best regards
Andrey Pasashnikov
Astrakhan
Russia
