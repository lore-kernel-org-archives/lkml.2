Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab2DSVRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:17:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37406 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965159Ab2DSVRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:17:19 -0400
Message-Id: <20120419210821.983914688@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 39/68] xHCI: add XHCI_RESET_ON_RESUME quirk for VIA xHCI host
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elric Fu <elricfu1@gmail.com>

commit 457a4f61f9bfc3ae76e5b49f30f25d86bb696f67 upstream.

The suspend operation of VIA xHCI host have some issues and
hibernate operation works fine, so The XHCI_RESET_ON_RESUME
quirk is added for it.

This patch should base on "xHCI: Don't write zeroed pointer
to xHC registers" that is released by Sarah. Otherwise, the
host system error will ocurr in the hibernate operation
process.

This should be backported to stable kernels as old as 2.6.37,
that contain the commit c877b3b2ad5cb9d4fe523c5496185cc328ff3ae9
"xhci: Add reset on resume quirk for asrock p67 host".

Signed-off-by: Elric Fu <elricfu1@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -95,6 +95,8 @@ static void xhci_pci_quirks(struct devic
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_VIA)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
 }
 
 /* called during probe() after chip reset completes */


