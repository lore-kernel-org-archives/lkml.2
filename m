Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab2AIStz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:49:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525Ab2AIStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:49:51 -0500
Date: Mon, 9 Jan 2012 10:49:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Michael Buesch <m@bues.ch>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Incorrect uses of get_driver()/put_driver()
Message-ID: <20120109184944.GA24320@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1201091133400.1541-100000@iolanthe.rowland.org>
 <Pine.LNX.4.44L0.1201091202090.1541-100000@iolanthe.rowland.org>
 <20120109174836.GA32181@phenom.dumpdata.com>
 <20120109182045.GG15083@core.coreip.homeip.net>
 <20120109183414.GB1287@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109183414.GB1287@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 01:34:14PM -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 09, 2012 at 10:20:45AM -0800, Dmitry Torokhov wrote:
> > On Mon, Jan 09, 2012 at 12:48:36PM -0500, Konrad Rzeszutek Wilk wrote:
> > > On Mon, Jan 09, 2012 at 12:35:09PM -0500, Alan Stern wrote:
> > > > The get_driver() and put_driver() routines in the device core are not
> > > > documented well, and what they really do is quite different from what
> > > > people might think they do.  In particular, get_driver() does not
> > > > prevent a driver from being unregistered or unloaded -- the API which 
> > > > comes closest to doing that is try_module_get().
> > > > 
> > > > In fact, get_driver() and put_driver() are pretty much useless for
> > > > normal purposes, and Dmitry and I have been discussing getting rid of
> > > > them entirely.  But first we need to make sure that doing so won't mess
> > > > anything up.
> > > > 
> > > > The purpose of this email is to check with the maintainers of the
> > > > various drivers that seem to be using these routines in questionable
> > > > ways, to make sure nothing will go wrong.  Here are the places we have 
> > > > identified:
> > > > 
> > > > lib/dma-debug.c:173:  drv = get_driver(dev->driver);
> > > > lib/dma-debug.c:188:  put_driver(drv);
> > > > 
> > > > Joerg, these calls don't seem to do anything, as far as I can tell.  
> > > > Is there any reason to keep them?
> > > > 
> > > > drivers/pci/xen-pcifront.c:596:       if (get_driver(&pdrv->driver)) {
> > > > drivers/pci/xen-pcifront.c:626:               put_driver(&pdrv->driver);
> > > > 
> > > > Konrad, these calls don't seem to do anything either.
> > > > 
> > > 
> > > Looks like they should be replaced with the try_module_get() equivalant
> > > for the 'struct pci_driver'? Is there such one?
> > 
> > You seem to need stronger guarantees that the driver simply present in
> > memory. You need to make sure that the driver you fetched is kept being
> > bound to the device for entire duration of pcifront_common_process().
> 
> OK, any suggestions?

Nothing canned I'm afraid...

-- 
Dmitry
