Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968254Ab2ESAuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:50:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965130Ab2ESAue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:50:34 -0400
Date: Fri, 18 May 2012 17:50:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH -next] comedi: fix build when USB is not enabled
Message-ID: <20120519005031.GA27613@kroah.com>
References: <20120518184943.2c762e8441e53ea24748d1b8@canb.auug.org.au>
 <4FB6ED55.6090805@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB6ED55.6090805@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 05:46:13PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Calls to optional subsystems cannot be made indiscriminately.
> Enclose all of the usb helper functions inside
> #if IS_ENABLED(CONFIG_USB)
> to fix these build errors.
> 
> (The pci helper functions are OK since there are stubs in
> linux/pci.h for the called functions when PCI is not enabled.
> Possibly the same could be done for the called USB functions.)
> 
> ERROR: "usb_deregister" [drivers/staging/comedi/comedi.ko] undefined!
> ERROR: "usb_register_driver" [drivers/staging/comedi/comedi.ko] undefined!

I would rather stub these out in usb.h instead, care to make a patch for
that?

thanks,

greg k-h
