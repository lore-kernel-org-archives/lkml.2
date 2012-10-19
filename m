Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab2JSOaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:30:14 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:60831 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030382Ab2JSOaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:30:10 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 10:30:10 EDT
From: Ben Collins <ben.c@servergy.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: [PATCH] USB: ehci-fsl: Return valid error in ehci_fsl_setup_phy
Date: Fri, 19 Oct 2012 10:24:12 -0400
Message-Id: <590BC180-2D2F-47C3-B15F-E7B7BF9B5895@servergy.com>
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 6.1 \(1498\))
X-Mailer: Apple Mail (2.1498)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ehci_fsl_setup_phy is supposed to return an int, but had a void return
value in the case of controller_ver being invalid.

Signed-off-by: Ben Collins <ben.c@servergy.com>
Cc: Shengzhou Liu <Shengzhou.Liu@freescale.com>
---
 drivers/usb/host/ehci-fsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-fsl.c b/drivers/usb/host/ehci-fsl.c
index 9bfde82..0d2f35c 100644
--- a/drivers/usb/host/ehci-fsl.c
+++ b/drivers/usb/host/ehci-fsl.c
@@ -222,7 +222,7 @@ static int ehci_fsl_setup_phy(struct usb_hcd *hcd,
 
 	if (pdata->controller_ver < 0) {
 		dev_warn(hcd->self.controller, "Could not get controller version\n");
-		return;
+		return -ENODEV;
 	}
 
 	portsc = ehci_readl(ehci, &ehci->regs->port_status[port_offset]);
-- 
1.7.10.4
