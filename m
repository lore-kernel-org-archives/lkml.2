Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab1HVPzc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:55:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:52137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1HVPzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="40639523"
Date: Mon, 22 Aug 2011 08:55:29 -0700
From: Sarah Sharp <sarah.a.sharp@intel.com>
To: sifram rajas <sifram.rajas@gmail.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xhci: Redundant check for
Message-ID: <20110822155529.GA4783@xanatos>
References: <CA+OjSzyMGBsjCmwAgrFDkX3uphD9ya8DBGQw1nVktoKX=wpDHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+OjSzyMGBsjCmwAgrFDkX3uphD9ya8DBGQw1nVktoKX=wpDHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sifram,


On Mon, Aug 22, 2011 at 08:35:20AM -0700, sifram rajas wrote:
> Hi Sarah,
> 
> This patch is for linux-3.0.3.
> 
> In the xhci_check_args() function in xhci.c, there is a redundant
> check for xhci->devs.
> 
> This is redundant because the struct xhci_hcd->devs is actually
> defined as a static array
> of pointers and is not a pointer to a pointer.

Your patch looks fine, and I'll apply it to my usb-next branch later
this week.

However, can you please send future patches to
sarah.a.sharp@linux.intel.com, not my intel.com address?  The intel.com
one runs through a horrible exchange server that converts tabs to spaces
and makes it impossible to apply patches.

Where did you find the intel.com email address?  I'm pretty sure the
MAINTAINERS file lists the linux.intel.com one, and I'd like to make
sure people aren't getting bad information.

Sarah Sharp

> Signed-off-by: Sifram Rajas <sifram.rajas@gmail.com>
> ---
> drivers/usb/host/xhci.c |   3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> --- a/drivers/usb/host/xhci.c	2011-08-17 23:27:16.000000000 +0530
> +++ b/drivers/usb/host/xhci.c	2011-08-22 20:43:34.250000000 +0530
> @@ -945,8 +945,7 @@ static int xhci_check_args(struct usb_hc
>  		return -ENODEV;
> 
>  	if (check_virt_dev) {
> -		if (!udev->slot_id || !xhci->devs
> -			|| !xhci->devs[udev->slot_id]) {
> +		if (!udev->slot_id || !xhci->devs[udev->slot_id]) {
>  			printk(KERN_DEBUG "xHCI %s called with unaddressed "
>  						"device\n", func);
>  			return -EINVAL;
> 
> Thanks,
> Sifram Rajas.
