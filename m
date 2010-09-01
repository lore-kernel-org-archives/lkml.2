Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0IAWNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:13:09 -0400
Received: from kroah.org ([198.145.64.141]:49160 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab0IAWNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:13:07 -0400
Date: Wed, 1 Sep 2010 14:10:17 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 03/13] USB: gadget: composite: Better string override
 handling
Message-ID: <20100901211017.GA8173@kroah.com>
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 05:43:46PM +0200, Michal Nazarewicz wrote:
> The iManufatcurer, iProduct and iSerialNumber composite module
> parameters were only used when the gadget driver registers
> strings for manufacturer, product and serial number.  If the
> gadget never bothered to set corresponding fields in USB device
> descriptors those module parameters are ignored.
> 
> This commit makes the parameters work even if the strings ID
> have not been assigned.  It also changes the way IDs are
> overridden -- what IDs are overridden is now saved in
> usb_composite_dev structure -- which makes it unnecessary to
> modify the string tables the way previous code did.
> 
> The commit also adds a iProduct and iManufatcurer fields to the
> usb_composite_device structure.  If they are set, appropriate
> strings are reserved and added to device descriptor.  This makes
> it unnecessary for gadget drivers to maintain code for setting
> those.  If iProduct is not set it defaults to
> usb_composite_device::name; if iManufatcurer is not set
> a default "<system> <release> with <gadget-name>" is used.
> 
> The last thing is that if needs_serial field of
> usb_composite_device is set and user failed to provided
> iSerialNumber parameter a warning is issued.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This patch doesn't apply on the latest tree, care to respin it, and the
ones after it as well?

thanks,

greg k-h
