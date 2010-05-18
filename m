Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab0ERUOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 16:14:23 -0400
Received: from kroah.org ([198.145.64.141]:52606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758227Ab0ERUOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 16:14:19 -0400
Date: Tue, 18 May 2010 13:13:37 -0700
From: Greg KH <greg@kroah.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Bill Davidsen <davidsen@tmr.com>, CaT <cat@zip.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, bzolnier@gmail.com,
       stable@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34 (rt2860 regression)
Message-ID: <20100518201337.GE20223@kroah.com>
References: <alpine.LFD.2.00.1005161430100.4195@i5.linux-foundation.org>
 <20100518114426.GY2657@zip.com.au>
 <20100518125539.GA23181@kroah.com>
 <20100518131706.GZ2657@zip.com.au>
 <20100518133336.GA23591@kroah.com>
 <4BF2C78A.7090903@tmr.com>
 <20100518183713.GS16821@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518183713.GS16821@decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 07:37:14PM +0100, Ben Hutchings wrote:
> On Tue, May 18, 2010 at 12:59:54PM -0400, Bill Davidsen wrote:
> > Greg KH wrote:
> >> On Tue, May 18, 2010 at 11:17:06PM +1000, CaT wrote:
> >>> On Tue, May 18, 2010 at 05:55:39AM -0700, Greg KH wrote:
> >>>> I do not understand.  The firmware is now part of the linux-firmware
> >>>> tree, and if you install that, it is working just fine, right?  We moved
> >>>> the firmware out of the kernel tree on purpose.
> >>>>
> >>>> So what is the problem here?
> >>> Well, the driver used to work and appears to be useless without it. I guess
> >>> I'm wondering why it was kept out of the firmware directory where all the
> >>> other firmware lives (and so allow the driver to simply continue to work
> >>> and allow it to be compiled in).
> >>
> >> Because we are not adding new firmware to the kernel tree wherever
> >> possible, but instead, putting it in the separate linux-firmware tree.
> >>
> > I don't think that's the case here, he's not asking that new firmware be 
> > put in the kernel, just that existing firmware not be taken out.
> 
> New firmware should not be added to the kernel.  This rule has been
> documented since v2.6.30.  Now this rule (like many others) is relaxed for
> staging, but you can expect that firmware will be removed as part of the
> cleanup process to make staging drivers follow the rules.

Yes, that is why these firmware blobs are being moved out.  They
originally came in with the initial import of the driver to the staging
tree.  And then, as part of the cleanup process, move out to the correct
interfaces that we have in the kernel for such things.

> > Obviously firmware needs to be in the kernel image, or the building of 
> > initram becomes really nasty for NFS root systems.
> 
> Modules that load firmware should have modinfo giving the filenames they
> may requested.  Initramfs builders use that to find the files to include.

Yes, this should "just work" already for this driver.  If not, please
let us know and we will be glad to fix it.

thanks,

greg k-h
