Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423000Ab2I1UsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:48:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55320 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422969Ab2I1UsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:07 -0400
X-Sasl-enc: CIUkmFTVGwsKD7Xp2HJcXmRyuZPJnTyXayi8jeT7mTuF 1348865286
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 079/127] xhci: Fix a logical vs bitwise AND bug
Date: Fri, 28 Sep 2012 13:34:12 -0700
Message-Id: <20120928203055.128703819@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 052c7f9ffb0e95843e75448d02664459253f9ff8 upstream.

The intent was to test whether the flag was set.

This patch should be backported to stable kernels as old as 3.0, since
it fixes a bug in commit e95829f474f0db3a4d940cae1423783edd966027 "xhci:
Switch PPT ports to EHCI on shutdown.", which was marked for stable.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -594,7 +594,7 @@ void xhci_shutdown(struct usb_hcd *hcd)
 {
 	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
 
-	if (xhci->quirks && XHCI_SPURIOUS_REBOOT)
+	if (xhci->quirks & XHCI_SPURIOUS_REBOOT)
 		usb_disable_xhci_ports(to_pci_dev(hcd->self.controller));
 
 	spin_lock_irq(&xhci->lock);


