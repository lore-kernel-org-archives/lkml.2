Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0GNQO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:14:27 -0400
Received: from gandalf.light-speed.de ([85.214.152.96]:52481 "EHLO
	mail.light-speed.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab0GNQOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:14:25 -0400
X-Greylist: delayed 1109 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jul 2010 12:14:25 EDT
Message-ID: <4C3DDDFF.5040302@letzte-bankreihe.de>
Date: Wed, 14 Jul 2010 17:55:43 +0200
From: Stephan Wolf <stephan@letzte-bankreihe.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100628 Thunderbird/3.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, tglx@linutronix.de
Subject: [PATCH] enable readback to get HPET working on ATI SB4x00, kernel
 2.6.35_rc5
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  After commit 30a564be9d9554c168a654eddc2165869cc0d7bf 
"x86, hpet: Restrict read back to affected ATI chipsets" hpet did not 
work anymore on HP nx6325. The machine hangs on booting until a 
keystroke was taken. After a short time machine hangs again until next 
keystroke. Applying the following patch solves the issue for me.

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index e72d3fc..8d28924 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -408,6 +408,7 @@ static void ati_force_enable_hpet(struct pci_dev *dev)
      dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at 0x%lx\n",
             force_hpet_address);
      cached_dev = dev;
+    hpet_readback_cmp = 1;
  }
  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, 
PCI_DEVICE_ID_ATI_IXP400_SMBUS,
               ati_force_enable_hpet);

Signed-off-by: Stephan Wolf <stephan@letzte-bankreihe.de>
