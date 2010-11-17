Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935387Ab0KQTYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:24:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:43435 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934924Ab0KQTYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:24:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,212,1288594800"; 
   d="scan'208";a="574820322"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.37-rc2] iTCO_wdt: TCO Watchdog patch for Intel Patsburg PCH
Date: Wed, 17 Nov 2010 12:15:08 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011171115.08544.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an additional LPC Controller DeviceID for the Intel Patsburg PCH for TCO Watchdog.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37-rc2/drivers/watchdog/iTCO_wdt.c.orig	2010-11-17 10:02:03.000000000 -0800
+++ linux-2.6.37-rc2/drivers/watchdog/iTCO_wdt.c	2010-11-17 10:03:42.000000000 -0800
@@ -32,6 +32,7 @@
  *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
  *	document number TBD                   : Cougar Point (CPT)
+ *	document number TBD                   : Patsburg (PBG)
  */
 
 /*
@@ -146,7 +147,8 @@
 	TCO_CPT29,	/* Cougar Point */
 	TCO_CPT30,	/* Cougar Point */
 	TCO_CPT31,	/* Cougar Point */
-	TCO_PBG,	/* Patsburg */
+	TCO_PBG1,	/* Patsburg */
+	TCO_PBG2,	/* Patsburg */
 };
 
 static struct {
@@ -235,6 +237,7 @@
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
 	{"Patsburg", 2},
+	{"Patsburg", 2},
 	{NULL, 0}
 };
 
@@ -350,7 +353,8 @@
 	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
 	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
-	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG)},
+	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
+	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
