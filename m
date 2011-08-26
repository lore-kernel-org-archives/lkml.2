Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1H0O4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1H0O4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:19 2011
Message-Id: <20110826220119.732358946@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        JiSheng Zhang <jszhang3@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [01/19] USB: xhci: fix OS want to own HC
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: JiSheng Zhang <jszhang3@gmail.com>

commit 6768458b17f9bf48a4c3a34e49b20344091b5f7e upstream.

Software should set XHCI_HC_OS_OWNED bit to request ownership of xHC.

This patch should be backported to kernels as far back as 2.6.31.

Signed-off-by: JiSheng Zhang <jszhang3@gmail.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -444,7 +444,7 @@ static void __devinit quirk_usb_handoff_
 
 	/* If the BIOS owns the HC, signal that the OS wants it, and wait */
 	if (val & XHCI_HC_BIOS_OWNED) {
-		writel(val & XHCI_HC_OS_OWNED, base + ext_cap_offset);
+		writel(val | XHCI_HC_OS_OWNED, base + ext_cap_offset);
 
 		/* Wait for 5 seconds with 10 microsecond polling interval */
 		timeout = handshake(base + ext_cap_offset, XHCI_HC_BIOS_OWNED,


