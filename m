Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1JQFda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 01:33:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1JQFd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 01:33:28 -0400
Date: Sun, 16 Oct 2011 18:45:27 -0700
From: Greg KH <gregkh@suse.de>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] PCI, sys: only create rescan under
 /sys/.../pci/devices/... for pci bridges
Message-ID: <20111017014527.GA7322@suse.de>
References: <4E9A3092.4080309@oracle.com>
 <4E9A3436.3010704@oracle.com>
 <20111016023943.GA3787@suse.de>
 <4E9A6CCB.4060101@oracle.com>
 <20111016155517.GA6421@suse.de>
 <4E9B6A2F.1080706@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9B6A2F.1080706@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 04:35:11PM -0700, Yinghai Lu wrote:
> On 10/16/2011 08:55 AM, Greg KH wrote:
> 
> > On Sat, Oct 15, 2011 at 10:34:03PM -0700, Yinghai Lu wrote:
> >> On 10/15/2011 07:39 PM, Greg KH wrote:
> >>
> >>>
> >>> No, we already have a way to do this, this is not acceptable, sorry.
> >>>
> >>
> >>
> >> hope this one is ok...
> > 
> > Nope, not at all, don't use #ifdef in .c files.
> > 
> > Again, we have a way to do this, built into sysfs, that can dynamically
> > know to add or not add, attributes when they are registered with the
> > system.
> 
> thank you for the comments.
> 
> i got it. now introduce device type for pci dev.
> 
> please check if this one is what you want.
> 
> [PATCH -v3 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/... for pci bridges
> 
> Current code will create rescan for every pci device,
> that is not right. the device is already there, there is no reason to rescan it.
> 
> So only have rescan for pci bridges. less confusing
> 
> Also the rescan will rescan bridge's secondary bus instead of primary bus.
> 
> -v3: Use device_type for pci dev.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pci-sysfs.c |   39 +++++++++++++++++++++++++++++++++++++--
>  drivers/pci/pci.h       |    1 +
>  drivers/pci/probe.c     |    1 +
>  3 files changed, 39 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/pci/pci-sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-sysfs.c
> +++ linux-2.6/drivers/pci/pci-sysfs.c
> @@ -303,12 +303,15 @@ dev_rescan_store(struct device *dev, str
>  
>  	if (val) {
>  		mutex_lock(&pci_remove_rescan_mutex);
> -		pci_rescan_bus(pdev->bus);
> +		pci_rescan_bus(pdev->subordinate);
>  		mutex_unlock(&pci_remove_rescan_mutex);
>  	}
>  	return count;
>  }

This chunk is separate from the rest of the patch, right?

Please split this up into doing one thing per patch please.

greg k-h
