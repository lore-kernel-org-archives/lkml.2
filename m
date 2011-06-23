Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909Ab1FWR3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:63427 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726Ab1FWRXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:23:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ruben Smits <ruben.smits@mech.kuleuven.be>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 025/247] staging: comedi: add support for newer jr3 1-channel pci board
Date: Thu, 23 Jun 2011 13:17:48 -0400
Message-Id: <1308849690-14530-26-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ruben Smits <ruben.smits@mech.kuleuven.be>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6292817d58637f85dd623cfe563c7f5ec4f4c470 upstream.

add DEVICE_ID to table

Signed-off-by: Ruben Smits <ruben.smits@mech.kuleuven.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/comedi/drivers/jr3_pci.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index d330b18..db31dfb 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -53,6 +53,7 @@ Devices: [JR3] PCI force sensor board (jr3_pci)
 
 #define PCI_VENDOR_ID_JR3 0x1762
 #define PCI_DEVICE_ID_JR3_1_CHANNEL 0x3111
+#define PCI_DEVICE_ID_JR3_1_CHANNEL_NEW 0x1111
 #define PCI_DEVICE_ID_JR3_2_CHANNEL 0x3112
 #define PCI_DEVICE_ID_JR3_3_CHANNEL 0x3113
 #define PCI_DEVICE_ID_JR3_4_CHANNEL 0x3114
@@ -72,6 +73,8 @@ static DEFINE_PCI_DEVICE_TABLE(jr3_pci_pci_table) = {
 	{
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
+	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_1_CHANNEL_NEW,
+		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_2_CHANNEL,
 		    PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, {
 	PCI_VENDOR_ID_JR3, PCI_DEVICE_ID_JR3_3_CHANNEL,
@@ -808,6 +811,10 @@ static int jr3_pci_attach(struct comedi_device *dev,
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
-- 
1.7.4.4

