Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965521Ab2EOCac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:30:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:49859 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965481Ab2EOCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 156/179] USB: xhci: fix OS want to own HC
Date: Mon, 14 May 2012 22:14:12 -0400
Message-ID: <1337048075-6132-157-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JiSheng Zhang <jszhang3@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6768458b17f9bf48a4c3a34e49b20344091b5f7e upstream.

Software should set XHCI_HC_OS_OWNED bit to request ownership of xHC.

This patch should be backported to kernels as far back as 2.6.31.

Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index bcf7a88..eae8b18 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -444,7 +444,7 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 
 	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
 	if (val & XHCI_HC_BIOS_OWNED) {
-		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
+		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
 
 		/* Wait for 5 seconds with 10 microsecond polling interval */
 		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,
-- 
1.7.9.6

