Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab2A0PYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:24:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44918 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755071Ab2A0PYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:24:42 -0500
Date: Fri, 27 Jan 2012 10:24:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Greg KH <greg@kroah.com>, <linux-next@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Buesch <m@bues.ch>, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: linux-next: build failure after merge of the driver-core tree
In-Reply-To: <20120127135912.e5f45bf1c4a99b114c18bf72@canb.auug.org.au>
Message-ID: <Pine.LNX.4.44L0.1201271021550.1364-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012, Stephen Rothwell wrote:

> Hi Greg,
> 
> After merging the driver-core tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/pci/xen-pcifront.c: In function 'pcifront_common_process':
> drivers/pci/xen-pcifront.c:596:6: error: used struct type value where scalar is required
> 
> Caused by commit f3ff9247088a ("Remove useless get_driver()/put_driver()
> calls").
> 
> Please build test this stuff ...
> 
> I have used the driver-core tree from next-20120125 for today.

Sorry about the mistake.  I don't always build-test everything because 
it's not easy to do it on my system.  Anyway, the patch below will 
fix the problem.

Alan Stern

-----------------------------------------------------------------
Subject: [PATCH] PCI/XEN: Fix bug introduced by a recent change

This patch (as1516) fixes a bug introduced during the removal of
put_driver() and get_driver() from drivers/pci/xen-pcifront.c.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

 drivers/pci/xen-pcifront.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: usb-3.3/drivers/pci/xen-pcifront.c
===================================================================
--- usb-3.3.orig/drivers/pci/xen-pcifront.c
+++ usb-3.3/drivers/pci/xen-pcifront.c
@@ -593,7 +593,7 @@ static pci_ers_result_t pcifront_common_
 	}
 	pdrv = pcidev->driver;
 
-	if (pdrv->driver) {
+	if (pdrv) {
 		if (pdrv->err_handler && pdrv->err_handler->error_detected) {
 			dev_dbg(&pcidev->dev,
 				"trying to call AER service\n");

