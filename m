Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab1HDAaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 20:30:52 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:19140 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755913Ab1HDAas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 20:30:48 -0400
Message-ID: <06E5A35FD5B340D6A7022BD0298B1A83@hacdom.okisemi.com>
From: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>
To: "Toshiharu Okada" <toshiharu-linux@dsn.okisemi.com>,
        <grant.likely@secretlab.ca>, <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Cc: <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>, <tomoya-linux@dsn.okisemi.com>
References: <1311141414-12867-1-git-send-email-toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] spi_topcliff_pch: supports a spi mode setup and bit order setup by IO control
Date: Thu, 4 Aug 2011 09:20:10 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Could you review this patch?
Thanks in advance.

Best Regards
Toshiharu Okada
----- Original Message ----- 
Sent: Wednesday, July 20, 2011 2:56 PM
Subject: [PATCH] spi_topcliff_pch: supports a spi mode setup and bit order 
setup by IO control


This patch supports a spi mode setup and bit order setup by IO control.
    spi mode:     mode 0 to mode 3
    bit order:    LSB first, MSB first

Signed-off-by: Toshiharu Okada <toshiharu-linux@dsn.okisemi.com>
---
 drivers/spi/spi_topcliff_pch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
index 79e48d4..dec83c9 100644
--- a/drivers/spi/spi_topcliff_pch.c
+++ b/drivers/spi/spi_topcliff_pch.c
@@ -1038,6 +1038,7 @@ static int pch_spi_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  master->num_chipselect = PCH_MAX_CS;
  master->setup = pch_spi_setup;
  master->transfer = pch_spi_transfer;
+ master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
  dev_dbg(&pdev->dev,
  "%s transfer member of SPI master initialized\n", __func__);

-- 
1.7.4.4

