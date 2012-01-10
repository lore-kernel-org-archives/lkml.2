Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934581Ab2AJXEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:04:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934568Ab2AJXEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:04:35 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:04 2012
Message-Id: <20120110215604.661388715@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [36/49] USB: pxa168: Fix compilation error
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>

commit 35657c4d72925936c7219cc5caac118ca632acc2 upstream.

After commit c430131a02d677aa708f56342c1565edfdacb3c0 (Support
controllers with big endian capability regs), HC_LENGTH takes
two arguments. This patch fixes following compilation error:

In file included from drivers/usb/host/ehci-hcd.c:1323:
drivers/usb/host/ehci-pxa168.c:302:54: error: macro "HC_LENGTH" requires 2 arguments, but only 1 given
In file included from drivers/usb/host/ehci-hcd.c:1323:
drivers/usb/host/ehci-pxa168.c: In function 'ehci_pxa168_drv_probe':
drivers/usb/host/ehci-pxa168.c:302: error: 'HC_LENGTH' undeclared (first use in this function)
drivers/usb/host/ehci-pxa168.c:302: error: (Each undeclared identifier is reported only once
drivers/usb/host/ehci-pxa168.c:302: error: for each function it appears in.)

Signed-off-by: Tanmay Upadhyay <tanmay.upadhyay@einfochips.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-pxa168.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-pxa168.c
+++ b/drivers/usb/host/ehci-pxa168.c
@@ -299,7 +299,7 @@ static int __devinit ehci_pxa168_drv_pro
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs + 0x100;
 	ehci->regs = hcd->regs + 0x100 +
-		HC_LENGTH(ehci_readl(ehci, &ehci->caps->hc_capbase));
+		HC_LENGTH(ehci, ehci_readl(ehci, &ehci->caps->hc_capbase));
 	ehci->hcs_params = ehci_readl(ehci, &ehci->caps->hcs_params);
 	hcd->has_tt = 1;
 	ehci->sbrn = 0x20;


