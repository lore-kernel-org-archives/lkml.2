Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab2ENQIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:08:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756736Ab2ENQIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:08:42 -0400
From: Dave Airlie <airlied@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Airlie <airlied@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/vga: set the default device from the fixup.
Date: Mon, 14 May 2012 17:01:20 +0100
Message-Id: <1337011280-7166-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

Since Matthew's efi/vga changes on non-EFI machines we were failing
to tell the vgaarb/switcheroo what the default device was, this
sets the default device in the quirk if none has been set before.

This fixes the switcheroo on my T410s.

[hpa: please ack to put this on top of the other patches in my -next tree].

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>

---
 arch/x86/pci/fixup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index d0e6e40..cf81c02 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <asm/pci_x86.h>
+#include <asm/vga.h>
 
 static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 {
@@ -348,6 +349,8 @@ static void __devinit pci_fixup_video(struct pci_dev *pdev)
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
 		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
+		if (vga_default_device() == NULL)
+			vga_set_default_device(pdev);
 	}
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
-- 
1.7.6

