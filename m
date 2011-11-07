Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab1KGVtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 16:49:39 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35644 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab1KGVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 16:49:37 -0500
X-Sasl-enc: uK8zmow3iY7caT4i3ALHLBjHMNTUKY0+MXXIvYYTIae0 1320702576
Date: Mon, 7 Nov 2011 13:49:09 -0800
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Tim Vlaar <Tvlaar@ptgrey.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111107214909.GA13023@kroah.com>
References: <20111107201812.GA12822@xanatos>
 <Pine.LNX.4.44L0.1111071537170.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1111071537170.2004-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:53:59PM -0500, Alan Stern wrote:
> On Mon, 7 Nov 2011, Sarah Sharp wrote:
> 
> > > > Alan, won't this global limit on the usbfs URB buffer size effect
> > > > userspace drivers that are currently allocating large amounts of
> > > > buffers, but still respecting individual buffer limit of 16KB?  It seems
> > > > like the patch has the potential to break userspace drivers.
> > > 
> > > It might indeed.  A further enhancement would replace that 16-MB global
> > > constant with a sysfs attribute (a writable module parameter for
> > > usbcore).  Do you have any better suggestions?
> > 
> > No, I don't have any better suggestions, except take out the limit. ;)
> > 
> > I do understand why we don't want userspace to DoS the system by using
> > up too much DMA'able memory.  However, as I understand it, the usbfs
> > files are created by udev with root access only by default, and distros
> > may choose to install rules that have more permissive privileges.  A
> > device vendor may not be ensured that a udev rule with permissive access
> > will be present for their device, so I think they're likely to write
> > programs that require root access.  Or require root privileges to
> > install said udev rule.
> > 
> > At that point, the same userspace program that has root privileges in
> > order to access usbfs or create the udev rule can just load and unload
> > the usbcore module with an arbitrarily large global limit, and the
> > global limit doesn't really add any security.  So why add the extra
> > barrier?
> 
> This is a question of kernel policy, and I don't know what is the
> generally accepted approach to this sort of thing.  Maybe Greg or Alan
> Cox can comment.

You have to set the limit to something, otherwise a non-root user can
kill the box quite easily.  If the admin wants to set the system up so
that any user can use up all of the memory, they are free to do that,
but we can't have it be the default.

thanks,

greg k-h
