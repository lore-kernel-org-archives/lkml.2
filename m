Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1I1Wnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:43:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54228 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932548Ab1I1Wni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:43:38 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:38 2011
Message-Id: <20110928220138.070987124@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [121/244] x86, iommu: Mark DMAR IRQ as non-threaded
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 477694e71113fd0694b6bb0bcc2d006b8ac62691 upstream.

Mark this lowlevel IRQ handler as non-threaded. This prevents a boot
crash when "threadirqs" is on the kernel commandline. Also the
interrupt handler is handling hardware critical events which should
not be delayed into a thread.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1388,7 +1388,7 @@ int dmar_set_interrupt(struct intel_iomm
 		return ret;
 	}
 
-	ret = request_irq(irq, dmar_fault, 0, iommu->name, iommu);
+	ret = request_irq(irq, dmar_fault, IRQF_NO_THREAD, iommu->name, iommu);
 	if (ret)
 		printk(KERN_ERR "IOMMU: can't request irq\n");
 	return ret;


