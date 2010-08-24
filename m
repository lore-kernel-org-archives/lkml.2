Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0HXO6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:58:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47156 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab0HXO6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:58:11 -0400
Date: Tue, 24 Aug 2010 15:58:03 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@suse.de>
Cc: Joey Lee <jlee@novell.com>, trenn@suse.de, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis.Jansen@web.de
Subject: Re: [PATCH] Add intel drm blacklist to intel_opregion_present
	detect
Message-ID: <20100824145803.GB17629@srcf.ucam.org>
References: <4C7426DB020000230001F3A8@novprvlin0050.provo.novell.com> <20100824142219.GB16200@srcf.ucam.org> <20100824145130.GA26232@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824145130.GA26232@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 07:51:30AM -0700, Greg KH wrote:
> On Tue, Aug 24, 2010 at 03:22:19PM +0100, Matthew Garrett wrote:
> > Erm. Sorry about that - I just realised that there's actually a fairly 
> > significant problem with it :) Right now you'll perform the register 
> > call unconditionally on module load. You need to make sure that there's 
> > actually Poulsbo hardware in the system, either by registering as a 
> > proper PCI driver and calling acpi_video_register in your probe function 
> > (and unregister in your remove function) or walking the PCI device list 
> > looking for a psb device.
> 
> Ick, don't walk the pci device list, just register a "real" pci device
> and do it that way, it's much simpler and plays nicer with the driver
> model and the rest of the kernel.

My only concern with that (and it's not a strong one) is that it'll 
block the psb driver from binding. Of course, the psb driver should be 
doing the acpi handling itself anyway, so...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
