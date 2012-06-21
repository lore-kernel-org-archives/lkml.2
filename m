Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab2FUUYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 16:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760177Ab2FUUYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 16:24:40 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/9] PCI: Remove redundant debug output in pci_do_fixups
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Jun 2012 14:24:23 -0600
Message-ID: <20120621202423.16865.50394.stgit@amt.stowe>
In-Reply-To: <20120621202415.16865.6226.stgit@amt.stowe>
References: <20120621202415.16865.6226.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the boot argument 'initcall_debug' is specified, redundant debug
output occurs for each device as a quirk is applied:
  ...
  pci 0000:00:1a.0: calling quirk_usb_early_handoff+0x0/0x620
  calling  quirk_usb_early_handoff+0x0/0x620 @ 1 for 0000:00:1a.0
  pci fixup quirk_usb_early_handoff+0x0/0x620 returned after 32 usecs for 0000:00: 1a.0
  ...

This patch removes the redundancy by eliminating the first debug output
occurence in the sequence shown above when 'initcall_debug' is specified.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/quirks.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index a2d9d33..9c93558 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2953,11 +2953,12 @@ static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 		     f->vendor == (u16) PCI_ANY_ID) &&
 		    (f->device == dev->device ||
 		     f->device == (u16) PCI_ANY_ID)) {
-			dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 			if (initcall_debug)
 				do_one_fixup_debug(f->hook, dev);
-			else
+			else {
+				dev_dbg(&dev->dev, "calling %pF\n", f->hook);
 				f->hook(dev);
+			}
 		}
 }
 

