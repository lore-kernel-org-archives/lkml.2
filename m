Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1HWFJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 01:09:05 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50247 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1HWFJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 01:09:00 -0400
Date: Tue, 23 Aug 2011 15:08:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110823150854.2f6da7f66247c3d31b07e072@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first use in this function)

Caused by the interaction of the module.h split up with commit
72246da40f37 ("usb: Introduce DesignWare USB3 DRD Driver") from the usb
tree.

I have applied this patch for today (Greg, this should be applied to your
tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 23 Aug 2011 15:05:25 +1000
Subject: [PATCH] usb: include module.h in the DesignWare USB3 DRD driver

Fixes this build error:

drivers/usb/dwc3/dwc3-pci.c: In function 'dwc3_pci_init':
drivers/usb/dwc3/dwc3-pci.c:211:9: error: 'THIS_MODULE' undeclared (first use in this function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/dwc3/dwc3-pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 2578595..e3b77d2 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -38,6 +38,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
-- 
1.7.5.4

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
