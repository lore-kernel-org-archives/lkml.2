Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0K3VFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 16:05:13 -0500
Received: from kroah.org ([198.145.64.141]:35477 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0K3VFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 16:05:11 -0500
Date: Tue, 30 Nov 2010 12:55:33 -0800
From: Greg KH <greg@kroah.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH/RFC] core: add a function to safely try to get device
 driver owner
Message-ID: <20101130205533.GA7057@kroah.com>
References: <Pine.LNX.4.64.1011292043000.27962@axis700.grange>
 <201011301855.56228.laurent.pinchart@ideasonboard.com>
 <20101130183225.GA27680@kroah.com>
 <201011302143.09966.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011302143.09966.laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 09:43:09PM +0100, Laurent Pinchart wrote:
> > > The way we deal with this is to try_module_get() on the OMAP3 ISP driver
> > > in the subdev open() handlers. I'm of course opened to alternatives.
> > 
> > Do it like the rest of the kernel does it, lock the module in place with
> > the module pointer it passed to you before calling open in that module.
> > Nothing new here at all.
> 
> That doesn't work in this case, because we have two modules. Module A is the 
> master and instantiates an I2C device handled by module B. Module B creates a 
> character device and sets itself as the owner. When the corresponding device 
> node is opened, module B's refcount is incremented, but module A refcount 
> isn't, even though module B can call to module A through board code using 
> function pointers provided in the platform data.

Again, this is something we have been doing for years just fine.  Look
at the usb-serial core.  It "owns" the device node yet the child drivers
are the ones actually handling the data.

Just never call the function pointer unless the module is loaded, it's
that simple.  If you need to add proper module ownership to the platform
data pointers, so be it.

thanks,

greg k-h
