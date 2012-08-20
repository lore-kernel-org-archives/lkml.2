Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab2HTD7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 23:59:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025Ab2HTD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:58:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Gary E. Miller" <gem@rellim.com>
Subject: [ 20/32] xhci: Add Etron XHCI_TRUST_TX_LENGTH quirk.
Date: Sun, 19 Aug 2012 20:57:16 -0700
Message-Id: <20120820035650.662411172@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 5cb7df2b2d3afee7638b3ef23a5bcb89c6f07bd9 upstream.

Gary reports that with recent kernels, he notices more xHCI driver
warnings:

xhci_hcd 0000:03:00.0: WARN Successful completion on short TX: needs XHCI_TRUST_TX_LENGTH quirk?

We think his Etron xHCI host controller may have the same buggy behavior
as the Fresco Logic xHCI host.  When a short transfer is received, the
host will mark the transfer as successfully completed when it should be
marking it with a short completion.

Fix this by turning on the XHCI_TRUST_TX_LENGTH quirk when the Etron
host is discovered.  Note that Gary has revision 1, but if Etron fixes
this bug in future revisions, the quirk will have no effect.

This patch should be backported to kernels as old as 2.6.36, that
contain a backported version of commit
1530bbc6272d9da1e39ef8e06190d42c13a02733 "xhci: Add new short TX quirk
for Fresco Logic host."

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Gary E. Miller <gem@rellim.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -95,6 +95,7 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;


