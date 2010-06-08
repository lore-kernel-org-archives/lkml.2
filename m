Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab0FHXOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:14:38 -0400
Received: from kroah.org ([198.145.64.141]:35006 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab0FHXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:14:37 -0400
Date: Tue, 8 Jun 2010 15:05:22 -0700
From: Greg KH <greg@kroah.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>, achiang@hp.com
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
Message-ID: <20100608220522.GA12775@kroah.com>
References: <4C0774C6.4090000@suse.cz>
 <20100608143739.192a94cd@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608143739.192a94cd@virtuousgeek.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 02:37:39PM -0700, Jesse Barnes wrote:
> On Thu, 03 Jun 2010 11:24:22 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
> > Hi,
> > 
> > we have a system where there is a pci hotplug class device to be handled
> > by cpqphp, but it is not a bridge. But in cpqhpc_probe there is:
> > struct pci_bus *bus;
> > ...
> > bus = pdev->subordinate;
> > ...
> > bus->max_bus_speed = PCI_SPEED_66MHz_PCIX;
> > 
> > But as it is not a bridge, subordinate is NULL and the kernel crashes.
> > 
> > Any idea what would be a correct fix here?
> > 
> > The bugzilla entry is at:
> > https://bugzilla.novell.com/show_bug.cgi?id=609338
> 
> I don't think we have anyone actively working on CPQHPC these days.
> Seems like the simple patch would be to check whether pdev->subordinate
> or bus exists before using it...  Have you poked around for specs on
> this at all?

I don't think I even have the specs anymore.  I ported the code from 2.4
back in 2001 or so and got it merged.  I didn't think this device was
still even around in systems.

a simple check would be best.

thanks,

greg k-h
