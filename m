Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab1I1WiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:38:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab1I1WiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:38:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:25 2011
Message-Id: <20110928220125.665499011@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: [004/244] sfi: table irq 0xFF means no interrupt
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

commit a94cc4e6c0a26a7c8f79a432ab2c89534aa674d5 upstream.

According to the SFI specification irq number 0xFF means device has no
interrupt or interrupt attached via GPIO.

Currently, we don't handle this special case and set irq field in
*_board_info structs to 255.  It leads to confusion in some drivers.
Accelerometer driver tries to register interrupt 255, fails and prints
"Cannot get IRQ" to dmesg.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/platform/mrst/mrst.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -689,7 +689,9 @@ static int __init sfi_parse_devs(struct
 			irq_attr.trigger = 1;
 			irq_attr.polarity = 1;
 			io_apic_set_pci_routing(NULL, pentry->irq, &irq_attr);
-		}
+		} else
+			pentry->irq = 0; /* No irq */
+
 		switch (pentry->type) {
 		case SFI_DEV_TYPE_IPC:
 			/* ID as IRQ is a hack that will go away */


