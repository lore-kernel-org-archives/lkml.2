Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab1C3VGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:16640 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162Ab1C3VGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132791"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: ruben.smits@mech.kuleuven.be, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [31/275] staging: comedi: add support for newer jr3 1-channel pci board
Message-Id: <20110330210426.56CF73E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ruben Smits <ruben.smits@mech.kuleuven.be>

commit 6292817d58637f85dd623cfe563c7f5ec4f4c470 upstream.

add DEVICE_ID to table

Signed-off-by: Ruben Smits <ruben.smits@mech.kuleuven.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/staging/comedi/drivers/jr3_pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.35.y/drivers/staging/comedi/drivers/jr3_pci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/comedi/drivers/jr3_pci.c	2011-03-29 22:51:56.279283123 -0700
+++ linux-2.6.35.y/drivers/staging/comedi/drivers/jr3_pci.c	2011-03-29 23:02:58.842329792 -0700
@@ -53,6 +53,7 @@
 
 #define PCI_VENDOR_ID_JR3 0x1762
 #define PCI_DEVICE_ID_JR3_1_CHANNEL 0x3111
+#define PCI_DEVICE_ID_JR3_1_CHANNEL_NEW 0x1111
 #define PCI_DEVICE_ID_JR3_2_CHANNEL 0x3112
 #define PCI_DEVICE_ID_JR3_3_CHANNEL 0x3113
 #define PCI_DEVICE_ID_JR3_4_CHANNEL 0x3114
@@ -72,6 +73,8 @@
 	{
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
+	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW,
+		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL,
@@ -808,6 +811,10 @@
 					devpriv->n_channels = 1;
 				}
 				break;
+			case PCI_DEVICE_ID_JR3_1_CHANNEL_NEW:{
+					devpriv->n_channels = 1;
+				}
+				break;
 			case PCI_DEVICE_ID_JR3_2_CHANNEL:{
 					devpriv->n_channels = 2;
 				}
