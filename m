Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305Ab0GOSwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:52:43 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:57270 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934167Ab0GOSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:52:41 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19AHYQFzbVAhWCOtA7Z3Ui5Z2FtTJ+BbUO/Yx8qd0
	BYtbPG78l0SPLv
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 12/25] char: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:52:37 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: "Digi International, Inc" <Eng.Linux@digi.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152052.38060.PeterHuewe@gmx.de>
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
 drivers/char/epca.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index d9df46a..5dafcdb 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2762,10 +2762,10 @@ err_out:
 
 
 static struct pci_device_id epca_pci_tbl[] = {
-	{ PCI_VENDOR_DIGI, PCI_DEVICE_XR, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xr },
-	{ PCI_VENDOR_DIGI, PCI_DEVICE_XEM, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xem },
-	{ PCI_VENDOR_DIGI, PCI_DEVICE_CX, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_cx },
-	{ PCI_VENDOR_DIGI, PCI_DEVICE_XRJ, PCI_ANY_ID, PCI_ANY_ID, 0, 0, brd_xrj },
+	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XR), brd_xr },
+	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XEM), brd_xem },
+	{ PCI_VDEVICE(DIGI, PCI_DEVICE_CX), brd_cx },
+	{ PCI_VDEVICE(DIGI, PCI_DEVICE_XRJ), brd_xrj },
 	{ 0, }
 };
 
-- 
1.7.1

