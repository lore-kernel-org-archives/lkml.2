Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab1KWA7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:59:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757046Ab1KWAep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:53 2011
Message-Id: <20111123002553.245584197@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Mike Miller <mike.miller@hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [04/53] [SCSI] hpsa: Disable ASPM
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit e5a44df85e8d78e5c2d3d2e4f59b460905691e2f upstream.

The Windows driver .inf disables ASPM on hpsa devices. Do the same because the
selection of a non default ASPM policy can cause the device to hang.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/hpsa.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -3887,6 +3888,10 @@ static int __devinit hpsa_pci_init(struc
 		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
+
+	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");


