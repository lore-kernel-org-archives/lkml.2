Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab1KGTMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 14:12:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55187 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753212Ab1KGTMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 14:12:17 -0500
Date: Mon, 7 Nov 2011 14:12:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: Tim Vlaar <Tvlaar@ptgrey.com>, Greg KH <greg@kroah.com>,
        Markus Rechberger <mrechberger@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111107185255.GA9005@xanatos>
Message-ID: <Pine.LNX.4.44L0.1111071403290.2004-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Nov 2011, Sarah Sharp wrote:

> On Fri, Oct 14, 2011 at 08:33:29AM -0600, Greg KH wrote:
> > On Fri, Oct 14, 2011 at 10:05:41AM -0400, Alan Stern wrote:
> > > No, a much better approach is to remove all limits on individual
> > > transfer sizes and instead have a global limit on the total amount of
> > > all usbfs buffers in use at any time.  Maybe something like 16 MB; at 
> > > SuperSpeed, that's about about 30 ms worth of data.
> > 
> > That sounds quite reasonable.
> 
> Alan, won't this global limit on the usbfs URB buffer size effect
> userspace drivers that are currently allocating large amounts of
> buffers, but still respecting individual buffer limit of 16KB?  It seems
> like the patch has the potential to break userspace drivers.

It might indeed.  A further enhancement would replace that 16-MB global
constant with a sysfs attribute (a writable module parameter for
usbcore).  Do you have any better suggestions?

> I think that Point Grey's USB 3.0 webcam will be attempting to queue a
> series of bulk URBs that will be bigger than your 16MB global limit.

For SuperSpeed, 16 MB is rather on the low side.  For high speed it
amounts to about 1/3-second worth of data, which arguably is also a bit
low.  Increasing the default is easy enough, but the best choice isn't
obvious.

Alan Stern

