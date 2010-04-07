Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0DGMyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 08:54:21 -0400
Received: from mta-out.inet.fi ([195.156.147.13]:33067 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580Ab0DGMyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:54:20 -0400
Date: Wed, 7 Apr 2010 15:53:58 +0300
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] btusb: Raw mode and ACL/SCO data
Message-ID: <20100407155358.083823f9@bluegiga.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows sending ACL/SCO packets if device is in RAW mode.
Previously only command packets were allowed.

Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>


diff -ur orig/drivers/bluetooth/btusb.c linux-2.6.33.2/drivers/bluetooth/btusb.c
--- orig/drivers/bluetooth/btusb.c	2010-04-02 02:02:33.000000000 +0300
+++ linux-2.6.33.2/drivers/bluetooth/btusb.c	2010-04-07 15:17:55.696672710 +0300
@@ -663,7 +663,9 @@
 		break;
 
 	case HCI_ACLDATA_PKT:
-		if (!data->bulk_tx_ep || hdev->conn_hash.acl_num < 1)
+		if (!data->bulk_tx_ep ||
+		    (!test_bit(HCI_RAW, &hdev->flags) &&
+		     hdev->conn_hash.acl_num < 1))
 			return -ENODEV;
 
 		urb = usb_alloc_urb(0, GFP_ATOMIC);
@@ -680,7 +682,9 @@
 		break;
 
 	case HCI_SCODATA_PKT:
-		if (!data->isoc_tx_ep || hdev->conn_hash.sco_num < 1)
+		if (!data->isoc_tx_ep ||
+		    (!test_bit(HCI_RAW, &hdev->flags) &&
+		     hdev->conn_hash.sco_num < 1))
 			return -ENODEV;
 
 		urb = usb_alloc_urb(BTUSB_MAX_ISOC_FRAMES, GFP_ATOMIC);
