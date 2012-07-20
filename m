Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab2GTAPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 20:15:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61982 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666Ab2GTAPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 20:15:48 -0400
Date: Thu, 19 Jul 2012 17:15:44 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <abbotti@mev.co.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/90] staging: comedi: adv_pci1723: move
 comedi_pci_enable() into the attach
Message-ID: <20120720001544.GA15590@kroah.com>
References: <201207181830.48668.hartleys@visionengravers.com>
 <5007D568.2050401@mev.co.uk>
 <ADE657CA350FB648AAC2C43247A983F00206AA916472@AUSP01VMBX24.collaborationhost.net>
 <20120719231723.GA23010@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA9165BC@AUSP01VMBX24.collaborationhost.net>
 <20120719233506.GA12858@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F00206AA9165C1@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AA9165C1@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 06:58:38PM -0500, H Hartley Sweeten wrote:
> On Thursday, July 19, 2012 4:35 PM, gregkh wrote:
> > On Thu, Jul 19, 2012 at 06:31:23PM -0500, H Hartley Sweeten wrote:
> >> If the comedi pci drivers have the "attach_pci" callback defined, the
> >> PCI api does correctly probe the driver. The comedi_pci_auto_config()
> >> then passes the pci_dev directly to the driver and the search of the
> >> PCI space for the device is not required.
> >> 
> >> If the "attach_pci" callback is not defined, the comedi_pci_auto_config()
> >> then falls back to passing the bus/slot information to the driver and uses
> >> the "attach" callback. In this case we could probably fast-track the search
> >> by using pci_get_slot() instead of doing the for_each_pci_dev() loop.
> >> 
> >> I think the problem is the COMEDI_DEVCONFIG ioctl. The userspace
> >> utility 'comedi_config' uses that ioctl to link a device node to a
> >> comedi driver. That utility allows passing the bus/slot information
> >> but it's not required. This means we have to search the PCI space
> >> for the pci_dev that matches the driver.
> >
> > The ioctl shouldn't be needed anymore for PCI or USB devices, as the
> > kernel handles the matching of the driver to the device.  Even if it
> > didn't, there are other more "standard" ways that you can bind devices
> > to drivers (through sysfs.)
> 
> I think it's still needed for some of the devices that require external
> firmware. The comedi_config utility allows the user to remove the
> driver binding and then reattach to it while passing the firmware blob
> into the driver.

Why would the driver need to be unbound from the device to do this?

> Not saying any of this is valid... And yes, there probably is a more
> "standard" way to do this. I just need a hint of what that is... ;-)

The "bind" and "unbind" files in sysfs are for that.

thanks,

greg k-h
