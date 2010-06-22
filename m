Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab0FVWlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:41:49 -0400
Received: from kroah.org ([198.145.64.141]:58092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0FVWlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:41:47 -0400
Date: Tue, 22 Jun 2010 15:36:12 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 21 (staging/easycap)
Message-ID: <20100622223612.GB3898@kroah.com>
References: <20100621170056.2fcf10ad.sfr@canb.auug.org.au>
 <20100621090049.c7f11c2d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621090049.c7f11c2d.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 09:00:49AM -0700, Randy Dunlap wrote:
> On Mon, 21 Jun 2010 17:00:56 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100618:
> 
> 
> When CONFIG_USB is not enabled:
> 
> ERROR: "usb_kill_urb" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_deregister_dev" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_deregister" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_set_interface" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_register_dev" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_control_msg" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_submit_urb" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_get_dev" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_find_interface" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_register_driver" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_free_urb" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "usb_alloc_urb" [drivers/staging/easycap/easycap.ko] undefined!
> 
> 
> Adding "depends on USB" to EASYCAP is a good start.
> After that and enabling CONFIG_USB, build of easycap gets:
> 
> ERROR: "video_register_device" [drivers/staging/easycap/easycap.ko] undefined!
> ERROR: "video_unregister_device" [drivers/staging/easycap/easycap.ko] undefined!
> 
> because there is no media/video support enabled.  Also no SOUND enabled,
> so I expect there to be build errors associated with sound also, meaning that
> the Kconfig file should probably modified with something like
> 
> config EASYCAP
> +	depends on USB && VIDEO_DEV && SND
> 
> 
> This is something that the driver author should know the answer to and submit a
> patch for.

You are right, care to make up a patch for this?

thanks,

greg k-h
