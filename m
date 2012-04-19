Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933337Ab2DSVMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:12:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36240 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933318Ab2DSVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:53 -0400
Message-Id: <20120419210613.303194544@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Elric Fu <elricfu1@gmail.com>, Andiry Xu <andiry.xu@amd.com>
Subject: [ 26/59] xhci: Restore event ring dequeue pointer on resume.
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit fb3d85bc7193f23c9a564502df95564c49a32c91 upstream.

The xhci_save_registers() function saved the event ring dequeue pointer
in the s3 register structure, but xhci_restore_registers() never
restored it.  No other code in the xHCI successful resume path would
ever restore it either.  Fix that.

This should be backported to kernels as old as 2.6.37, that contain the
commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI: PCI power
management implementation".

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Elric Fu <elricfu1@gmail.com>
Cc: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -627,6 +627,7 @@ static void xhci_restore_registers(struc
 	xhci_writel(xhci, xhci->s3.irq_control, &xhci->ir_set->irq_control);
 	xhci_writel(xhci, xhci->s3.erst_size, &xhci->ir_set->erst_size);
 	xhci_write_64(xhci, xhci->s3.erst_base, &xhci->ir_set->erst_base);
+	xhci_write_64(xhci, xhci->s3.erst_dequeue, &xhci->ir_set->erst_dequeue);
 }
 
 static void xhci_set_cmd_ring_deq(struct xhci_hcd *xhci)


