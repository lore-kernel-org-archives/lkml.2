Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab0LIRZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:27301 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0LIRZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="866415059"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 05/11] sep: initialize driver copy of send and receive count with device
Date: Thu,  9 Dec 2010 09:31:31 -0800
Message-Id: <1291915891-18468-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 821d3b7..c800824 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -3538,6 +3538,11 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	/* Set the IMR register - open only GPR 2 */
 	sep_write_reg(sep, HW_HOST_IMR_REG_ADDR, (~(0x1 << 13)));
 
+	/* Read send/receive counters from SEP */
+	sep->reply_ct = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR2_REG_ADDR);
+	sep->reply_ct &= 0x3FFFFFFF;
+	sep->send_ct = sep->reply_ct;
+
 	dev_dbg(&sep->pdev->dev, "about to call request_irq\n");
 	/* Get the interrupt line */
 	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
-- 
1.6.3.3

