Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0HXViU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:38:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab0HXViR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:38:17 -0400
Date: Tue, 24 Aug 2010 14:35:19 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Joey Lee <jlee@novell.com>, trenn@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis.Jansen@web.de
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
 detect
Message-ID: <20100824213519.GD4979@suse.de>
References: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com>
 <20100824142219.GB16200@srcf.ucam.org>
 <20100824145130.GA26232@suse.de>
 <20100824145803.GB17629@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824145803.GB17629@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 03:58:03PM +0100, Matthew Garrett wrote:
> On Tue, Aug 24, 2010 at 07:51:30AM -0700, Greg KH wrote:
> > On Tue, Aug 24, 2010 at 03:22:19PM +0100, Matthew Garrett wrote:
> > > Erm. Sorry about that - I just realised that there's actually a fairly 
> > > significant problem with it :) Right now you'll perform the register 
> > > call unconditionally on module load. You need to make sure that there's 
> > > actually Poulsbo hardware in the system, either by registering as a 
> > > proper PCI driver and calling acpi_video_register in your probe function 
> > > (and unregister in your remove function) or walking the PCI device list 
> > > looking for a psb device.
> > 
> > Ick, don't walk the pci device list, just register a "real" pci device
> > and do it that way, it's much simpler and plays nicer with the driver
> > model and the rest of the kernel.
> 
> My only concern with that (and it's not a strong one) is that it'll 
> block the psb driver from binding. Of course, the psb driver should be 
> doing the acpi handling itself anyway, so...

If a system really does have this type of driver on it, it can unbind
this driver and then bind itself, from userspace, so I don't see a
problem with this.

thanks,

greg k-h
