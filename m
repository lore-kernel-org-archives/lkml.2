Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639Ab2BXP7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:59:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37383 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757465Ab2BXP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:59:40 -0500
Date: Fri, 24 Feb 2012 10:59:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Alex,Shi" <alex.shi@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <andiry.xu@amd.com>, <clemens@ladisch.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] usb: enable pci MSI/MSIX in usb core
In-Reply-To: <20120224100051.GF17178@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1202241050520.1168-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Felipe Balbi wrote:

> > > > > +			retval = request_irq(hcd->msix_entries[i].vector,
> > > > > +					(irq_handler_t)hcd->driver->msix_irq,
> > > 
> > > do you really need this cast here ?
> > 
> > Yes, otherwise the complain like here:
> > drivers/usb/core/hcd-pci.c:330: warning: passing argument 2 of ‘request_irq’ from incompatible pointer type
> > include/linux/interrupt.h:134: note: expected ‘irq_handler_t’ but argument is of type ‘enum irqreturn_t (* const)(int,  struct usb_hcd *)’
> 
> Alan, Sarah, is the definition of the IRQ handler wrong on the hc_driver
> structure ?

No.  It is never passed to request_irq().

> Alex, I think you should fix your definition for the msix_irq handler.

The second parameter in the prototype is supposed to be void *, not 
struct usb_hcd *.

Alan Stern

