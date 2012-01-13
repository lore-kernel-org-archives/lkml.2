Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2AMSjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:39:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40456 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2AMSjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:39:13 -0500
Date: Fri, 13 Jan 2012 11:39:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <michal.simek@petalogix.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Michal Simek <monstr@monstr.eu>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] USB: EHCI: Don't use NO_IRQ in xilinx ehci driver
Message-ID: <20120113183910.GB22767@ponder.secretlab.ca>
References: <Pine.LNX.4.44L0.1201121055370.1384-100000@iolanthe.rowland.org>
 <4F10151A.8000209@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F10151A.8000209@petalogix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 12:27:22PM +0100, Michal Simek wrote:
> Alan Stern wrote:
> >On Thu, 12 Jan 2012, Michal Simek wrote:
> >
> >>Drivers shouldn't use NO_IRQ. This driver is used
> >>by Microblaze and PPC. PPC defines NO_IRQ as 0
> >>and Microblaze has removed it.
> >>
> >>Signed-off-by: Michal Simek <monstr@monstr.eu>
> >>CC: Alan Stern <stern@rowland.harvard.edu>
> >>CC: Greg Kroah-Hartman <gregkh@suse.de>
> >>CC: Grant Likely <grant.likely@secretlab.ca>
> >>CC: linux-usb@vger.kernel.org
> >>CC: devicetree-discuss@lists.ozlabs.org
> >>---
> >> drivers/usb/host/ehci-xilinx-of.c |    2 +-
> >> 1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/drivers/usb/host/ehci-xilinx-of.c b/drivers/usb/host/ehci-xilinx-of.c
> >>index 32793ce..9c2cc46 100644
> >>--- a/drivers/usb/host/ehci-xilinx-of.c
> >>+++ b/drivers/usb/host/ehci-xilinx-of.c
> >>@@ -183,7 +183,7 @@ static int __devinit ehci_hcd_xilinx_of_probe(struct platform_device *op)
> >> 	}
> >> 	irq = irq_of_parse_and_map(dn, 0);
> >>-	if (irq == NO_IRQ) {
> >>+	if (!irq) {
> >> 		printk(KERN_ERR "%s: irq_of_parse_and_map failed\n", __FILE__);
> >> 		rv = -EBUSY;
> >> 		goto err_irq;
> >
> >Acked-by: Alan Stern <stern@rowland.harvard.edu>
> 
> Thanks Alan.
> 
> I have seen that Grant sent the same patch to lkml too.
> Here is the thread: http://lkml.org/lkml/2012/1/11/342
> 
> Grant: How fast do you think you are able to merge your patches?

Ignore my patch.  It won't go in until 3.4

g.

