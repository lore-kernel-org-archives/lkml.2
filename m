Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab2COKTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:19:08 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52509 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab2COKTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:19:04 -0400
MIME-Version: 1.0
Date: Thu, 15 Mar 2012 19:19:03 +0900
Message-ID: <CADTWAOL7aBi64yimwPubAJ22=4AQ1BRjzQCahUXUsbSa1oJ59A@mail.gmail.com>
Subject: [RESEND PATCH] mtd: fix section mismatch for doc_probe_device
From: Ryosuke Saito <raitosyo@gmail.com>
To: dwmw2@infradead.org
Cc: robert.jarzmik@free.fr, mikedunn@newsguy.com, ivan.djelic@parrot.com,
        artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doc_probe_device() is only called from docg3_probe() which is in .init.text,
so it must be in the same section to avoid a section mismatch warning.

Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>
---
 drivers/mtd/devices/docg3.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 25f688c..db9a4b7 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1846,8 +1846,8 @@ static void __init doc_set_driver_info(int
chip_id, struct mtd_info *mtd)
  * if a memory allocation failed. If floor 0 is checked, a reset of the ASIC is
  * launched.
  */
-static struct mtd_info *doc_probe_device(void __iomem *base, int floor,
-					 struct device *dev)
+static struct mtd_info * __init
+doc_probe_device(void __iomem *base, int floor, struct device *dev)
 {
 	int ret, bbt_nbpages;
 	u16 chip_id, chip_id_inv;
