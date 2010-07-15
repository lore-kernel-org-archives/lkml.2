Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380Ab0GOTAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:00:53 -0400
Received: from mail.gmx.net ([213.165.64.20]:28642 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934369Ab0GOTAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:00:50 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19plgt79KRp9gX5D5Di3+HijAEcAedXl9GShXd0X1
	Y8Z/7rVEntc4Ta
From: Peter Huewe <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 16/25] crypto: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 21:00:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Roel Kluin <roel.kluin@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Chihau Chau <chihau@gmail.com>, linux-geode@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152100.42276.PeterHuewe@gmx.de>
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
 drivers/crypto/geode-aes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 09389dd..219d09c 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -573,7 +573,7 @@ geode_aes_probe(struct pci_dev *dev, const struct pci_device_id *id)
 }
 
 static struct pci_device_id geode_aes_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES, PCI_ANY_ID, PCI_ANY_ID} ,
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), } ,
 	{ 0, }
 };
 
-- 
1.7.1

