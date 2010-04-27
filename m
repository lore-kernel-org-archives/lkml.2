Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0D0XTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:19:07 -0400
Received: from kroah.org ([198.145.64.141]:58762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab0D0XTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:19:03 -0400
Date: Tue, 27 Apr 2010 16:18:39 -0700
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another (third) dt3155 driver PCI/video4linux
 compliant
Message-ID: <20100427231839.GA26416@kroah.com>
References: <201003201118.36736.mitov@issp.bas.bg>
 <20100320130158.GA13682@kroah.com>
 <201003202140.16412.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003202140.16412.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 09:40:16PM +0200, Marin Mitov wrote:
> On 20.3.2010, Greg KH wrote:
> > On Sat, Mar 20, 2010 at 11:18:36AM +0200, Marin Mitov wrote:
> > > Hi Scott, Greg, all,
> > > 
> > > Here you will find a link to the source code for a dt3155 driver
> > > rewritten to be  PCI/video4linux compliant.
> > > 
> > > http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/
> > > 
> > > It works with xawtv (if the window is bigger than the acquired image).
> > > See 
> > > 
> > > http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/00README
> > > 
> > > for more details.
> > > 
> > > Any critics/comments will be appreciated.
> > 
> > Can you send it in patch form?  I can't really do anything with it like
> > this, sorry.
> > 
> > greg k-h
> 
> OK, here it is:
> 
> ======================================================
> 
> Kernel module (device driver) for dt3155 frame grabber
> video4linux2 compliant (finaly). Works with xawtv.
> 
> ======================================================
> 
> This driver is written (almost) from scratch, usung the
> allocator developed for dt3155pci see bellow). The driver
> uses videobuf-dma-contig interface modified to use the above
> mentioned allocator instead of dma_alloc_coheren().
> 
> The first thing to do was to design a new allocator based
> on allocating a configurable number of 4MB chunks of memory,
> that latter are broken into frame buffers of 768x576 bytes
> kept in different FIFOs (queues). As far as the driver autoloads
> as a kernel module during kernel boot, the allocation of 4MB
> chunks succeeds.
> 
> The driver keeps three FIFOs: one for 4MB chunks, one for free
> buffers (available for allocations) and one for buffers already
> allocated. Allocation/deallocation is done automatically though
> the video4linux videobuf subsystem (some pointers to functions
> are replaced by driver supplied functions).
> 
> Sure, there are problems:
> 
> 1. The device works by read() method only (for now).
> 
> 2. Works for CCIR, but should work for RS-170 (not tested)
>    This is made during kernel configuration.
> 
> 3. Could work for multiple dt3155 frame grabbers in a PC,
>    (private data is allocated during PCI probe() method), but
>    is not tested due to lack of a second board.
> 
> 4. Not tested on a BIG ENDIAN architecture.
> 
> 5. Many others you could find .... :-)
> 
> All critics, comments, suggestions are wellcome.

I like it, want me to apply it?  Right now it fails to build, but that
should be simple to fix up, I'll be glad to do that.

thanks,

greg k-h
