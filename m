Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390Ab0GOTB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:01:29 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58065 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934369Ab0GOTB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:01:26 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18c+2FA/rQcB3c/2N4DcVdoBDD4uyVKiTC7JUjWHy
	AynL+8x1jBm0HU
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 17/25] infiniband/hw/nes: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:01:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Julia Lawall <julia@diku.dk>, Tejun Heo <tj@kernel.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152101.21810.PeterHuewe@gmx.de>
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
 drivers/infiniband/hw/nes/nes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index de7b9d7..1f26927 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -110,8 +110,8 @@ static unsigned int sysfs_nonidx_addr;
 static unsigned int sysfs_idx_addr;
 
 static struct pci_device_id nes_pci_table[] = {
-	{PCI_VENDOR_ID_NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020, PCI_ANY_ID, PCI_ANY_ID},
-	{PCI_VENDOR_ID_NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020_KR, PCI_ANY_ID, PCI_ANY_ID},
+	{PCI_VDEVICE(NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020), },
+	{PCI_VDEVICE(NETEFFECT, PCI_DEVICE_ID_NETEFFECT_NE020_KR), },
 	{0}
 };
 
-- 
1.7.1

