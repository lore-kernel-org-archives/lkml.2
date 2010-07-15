Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab0GOTCH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:02:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:37499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934369Ab0GOTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:02:01 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19I+QdbJ/tImR5Ib4Img6c9NKYGrdMGABMwAGhkYH
	nx8fAZ9YSUzuN6
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 18/25] input/gameport: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:01:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        " =?iso-8859-1?q?M=E1rton?= =?iso-8859-1?q?_N=E9meth?=" 
	<nm127@freemail.hu>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152101.59421.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/input/gameport/fm801-gp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/gameport/fm801-gp.c b/drivers/input/gameport/fm801-gp.c
index 14d3f3e..fa8446e 100644
--- a/drivers/input/gameport/fm801-gp.c
+++ b/drivers/input/gameport/fm801-gp.c
@@ -141,7 +141,7 @@ static void __devexit fm801_gp_remove(struct pci_dev *pci)
 }
 
 static const struct pci_device_id fm801_gp_id_table[] = {
-	{ PCI_VENDOR_ID_FORTEMEDIA, PCI_DEVICE_ID_FM801_GP, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0  },
+	{ PCI_VDEVICE(FORTEMEDIA, PCI_DEVICE_ID_FM801_GP), 0 },
 	{ 0 }
 };
 
-- 
1.7.1

