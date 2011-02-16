Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab1BPBrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:47:36 -0500
Received: from kroah.org ([198.145.64.141]:38757 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab1BPATA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:29 2011
Message-Id: <20110216001428.977793830@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ruben Smits <ruben.smits@mech.kuleuven.be>
Subject: [039/272] staging: comedi: add support for newer jr3 1-channel pci board
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ruben Smits <ruben.smits@mech.kuleuven.be>

commit 6292817d58637f85dd623cfe563c7f5ec4f4c470 upstream.

add DEVICE_ID to table

Signed-off-by: Ruben Smits <ruben.smits@mech.kuleuven.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/drivers/jr3_pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -54,6 +54,7 @@ Devices: [JR3] PCI force sensor board (j
 
 #define PCI_VENDOR_ID_JR3 0x1762
 #define PCI_DEVICE_ID_JR3_1_CHANNEL 0x3111
+#define PCI_DEVICE_ID_JR3_1_CHANNEL_NEW 0x1111
 #define PCI_DEVICE_ID_JR3_2_CHANNEL 0x3112
 #define PCI_DEVICE_ID_JR3_3_CHANNEL 0x3113
 #define PCI_DEVICE_ID_JR3_4_CHANNEL 0x3114
@@ -73,6 +74,8 @@ static DEFINE_PCI_DEVICE_TABLE(jr3_pci_p
 	{
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
+	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW,
+		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL,
@@ -807,6 +810,10 @@ static int jr3_pci_attach(struct comedi_
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


