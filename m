Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2LBNgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:36:23 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49305 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2LBNgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:36:22 -0500
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 08:36:22 -0500
Message-ID: <CAPgLHd_0FZAtGnshNqD3RkGD9Qr+85vfxd2joSoc4U6Ef8JdKQ@mail.gmail.com>
Subject: [PATCH -next] mfd: sta2x11-mfd: fix potential NULL pointer
 dereference in __sta2x11_mfd_mask()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The dereference to 'mfd' should be moved below the NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/sta2x11-mfd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 012a521..1ecbdfb 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -116,12 +116,14 @@ u32 __sta2x11_mfd_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val,
 	struct sta2x11_mfd *mfd = sta2x11_mfd_find(pdev);
 	u32 r;
 	unsigned long flags;
-	void __iomem *regs = mfd->regs[index];
+	void __iomem *regs;
 
 	if (!mfd) {
 		dev_warn(&pdev->dev, ": can't access sctl regs\n");
 		return 0;
 	}
+
+	regs = mfd->regs[index];
 	if (!regs) {
 		dev_warn(&pdev->dev, ": system ctl not initialized\n");
 		return 0;


