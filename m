Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab0FJWeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:34:44 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53183 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0FJWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:34:43 -0400
Date: Thu, 10 Jun 2010 16:34:36 -0600
From: Alex Chiang <achiang@canonical.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-pci@vger.kernel.org,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: cpqphp: NULL ptr deref in cpqhpc_probe
Message-ID: <20100610223436.GE8257@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jiri Slaby <jslaby@suse.cz>, linux-pci@vger.kernel.org,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>
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

Hi,

My hp.com address is dead. This is my new address.

Luckily, I just happened to be scanning LKML and thought "who
would be crazy enough to be touching cpqphp?" :)

* Jesse Barnes <jbarnes@virtuousgeek.org>:
> Jiri Slaby <jslaby@suse.cz> wrote:
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

I think Greg/Jesse's suggestion is correct - just return if it's
not a bridge.

I managed to find an ancient machine that actually had this
hardware but never had time to work on it, and then switched
jobs. As far as I know, the hardware is still there, with my old
group.

But I seriously think it's just time to rip this driver out of
the tree. If anyone is actually using this driver to do hotplug,
I will personally buy that person a full half-barrel of
Colorado's finest microbrew of choice in order to numb the pain
of making poor career decisions. Hell, we can drink it together,
during which time I'll hack on the driver. The code surely can't
get any worse.

The occasional bug report shows that it's just more of a
maintenance burden than anything else.

/ac
