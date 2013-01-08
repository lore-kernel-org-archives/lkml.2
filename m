Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab3AHJ6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:58:38 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45687 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3AHJ6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:58:36 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r089vU24032613
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH v4 3/8] MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
Date: Tue, 8 Jan 2013 17:57:24 +0800
Message-ID: <cfe252a384bd9a5984af9b0a8300522496a1533f.1357638064.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1357638064.git.wei_wang@realsil.com.cn>
References: <cover.1357638064.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Realtek PCIe card reader only supports 32bit DMA.
This declaration can improve the readability

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index fa2c2bc..1dc64bb 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1010,6 +1010,10 @@ static int __devinit rtsx_pci_probe(struct pci_dev *pcidev,
 		pci_name(pcidev), (int)pcidev->vendor, (int)pcidev->device,
 		(int)pcidev->revision);
 
+	ret = pci_set_dma_mask(pcidev, DMA_BIT_MASK(32));
+	if (ret < 0)
+		return ret;
+
 	ret = pci_enable_device(pcidev);
 	if (ret)
 		return ret;
-- 
1.7.9.5

