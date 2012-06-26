Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab2FZRva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:51:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62466 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab2FZRv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:51:28 -0400
Date: Tue, 26 Jun 2012 10:51:21 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Alexis Cortes <alexis.cortes@ti.com>
Cc: "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, "'Quach, Brian'" <brian.quach@ti.com>,
        "'Llamas, Jorge'" <jorge.llamas@ti.com>
Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
Message-ID: <20120626175121.GA2831@kroah.com>
References: <002801cd4e68$a4b4f3a0$ee1edae0$@cortes@ti.com>
 <20120619223928.GD21104@xanatos>
 <004101cd4f33$755e8eb0$601bac10$@cortes@ti.com>
 <20120621000734.GB32743@xanatos>
 <003701cd4fde$fd969290$f8c3b7b0$@cortes@ti.com>
 <20120622163214.GC629@xanatos>
 <20120622164704.GA6896@kroah.com>
 <4fe9f0c8.04c1b60a.11cc.3ca4SMTPIN_ADDED@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fe9f0c8.04c1b60a.11cc.3ca4SMTPIN_ADDED@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 12:26:29PM -0500, Alexis Cortes wrote:
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@linuxfoundation.org]
> > Sent: Friday, June 22, 2012 11:47 AM
> > To: Sarah Sharp
> > Cc: Alexis Cortes; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org;
> > 'Quach, Brian'; 'Llamas, Jorge'
> > Subject: Re: [PATCH] usb: host: xhci: Compliance Mode port recovery
> > 
> > On Fri, Jun 22, 2012 at 09:32:14AM -0700, Sarah Sharp wrote:
> >> This is really going to suck from a power management perspective.
> >> "How do I stop the timer from polling?"  "Oh, you plug a device into
> >> every single port"  "But there's an internal port with nothing
> connected!"
> >> "Uhhh..."
> >>
> >> Greg, are you sure wouldn't consider a sysfs file for changing the
> >> polling interval?
> > 
> > What I really want is a list of the PCI devices that this is affected in,
> > I'm sure that this can be found, as what else would Windows be doing?
> 
> The redriver is completely transparent to the OS and the issue will affect
> all xHCI host controllers.

Ouch.  There's no way to detect by known PCI ids of the devices that you
know have been shipped with this in it?

> > Alexis, what are you going to do about this for Windows?  Why not solve it
> > the same way here for Linux?
> 
> We have implemented a 2 second polling in our Windows XP/Vista/7 xHCI driver
> and are currently engaging with Microsoft to implement a workaround for the
> inbox Win8 driver.

Good luck with that :)

Seriously, 2 seconds isn't that bad, but it can be noticable on some
systems that are in idle mode, as I'm sure you have measured.

greg k-h
