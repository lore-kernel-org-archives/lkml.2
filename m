Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab2KTBNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:13:13 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:48317 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab2KTBNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:13:10 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID qAK1CTnQ011611, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <arnd@arndb.de>, <oakad@yahoo.com>, <bp@alien8.de>,
        Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 1/2] mmc: Configure SD_CFG2 register in sd_rw_multi
Date: Tue, 20 Nov 2012 09:12:29 +0800
Message-ID: <d26d1ae11c300cd96ed01a72cc099fe6d813d7c2.1353373737.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1353373737.git.wei_wang@realsil.com.cn>
References: <cover.1353373737.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 0e934bf..067dd46 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -405,6 +405,7 @@ static int sd_rw_multi(struct realtek_pci_sdmmc *host, struct mmc_request *mrq)
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
 			0x01, RING_BUFFER);
 
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_CFG2, 0xFF, cfg2);
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, SD_TRANSFER, 0xFF,
 			trans_mode | SD_TRANSFER_START);
 	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, SD_TRANSFER,
-- 
1.7.9.5

