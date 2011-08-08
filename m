Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab1HHRWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:22:35 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:44505 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab1HHRWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:22:33 -0400
Date: Mon, 8 Aug 2011 13:22:16 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110808172216.GA2311@flamenco.cs.columbia.edu>
References: <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
 <20110805090416.GA4806@becoht-mvanga>
 <4E3BB6E7.6020809@ge.com>
 <20110805174728.GA1741@flamenco.cs.columbia.edu>
 <4E3F97EA.2020600@ge.com>
 <20110808091432.GA19570@flamenco.cs.columbia.edu>
 <4E3FABDA.8080204@ge.com>
 <20110808101140.GA21300@flamenco.cs.columbia.edu>
 <4E3FC33D.2080202@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3FC33D.2080202@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 08, 2011 at 12:06:37 +0100, Martyn Welch wrote:
> On 08/08/11 11:11, Emilio G. Cota wrote:
> > On Mon, Aug 08, 2011 at 10:26:50 +0100, Martyn Welch wrote:
> >> On 08/08/11 10:14, Emilio G. Cota wrote:
> >>> Martyn, no one in the kernel is doing what you propose, for
> >>> good reason. Look at USB, PCI, RapidIO.  They all provide get
> >>> and put functions to be called from probe and release.
> >>
> >> Really, which functions are these for PCI?
> > 
> > pci_get_dev/put in drivers/pci/pci-driver.c.
> > 
> 
> Which isn't explicitly used by the vast majority of PCI drivers. In fact the
> instances which I did find where this was used by a PCI device driver, it
> appears to be using the old-style PCI probing.

> This is taken care of automatically for drivers using the "newer" PCI driver
> registration model as part of the probe.

And I don't care. The new model is not doing that nor what you suggest
anyway, AFAIK it's not incrementing any refcounts for devices--perhaps
because it cannot be built as a module? I dunno.

Look at other subsystems that usually sit under PCI, like USB
or RapidIO.

> No, your driver will be told the resource isn't available by vme_lm_request(),
> it would return null. It would then be up to you as the driver writer to
> handle that gracefully. In fact, just as you'd have to do if the location
> monitor was already being used by a different VME device driver which had
> positioned them where it needed them.

Ok, we may not oops, but this is unnecessary pain for the driver--and
probably not what the driver wanted.

> > Remember that we're writing a bus driver here, we shouldn't
> > get on the way of the drivers for the devices on the bus, no
> > matter how crazy they are.
> 
> Actually we're providing resource management and a bridge independent VME API
> for VME device drivers as part of a bus specific core, much as USB and PCI do.
> The VME bridge drivers bind under it, the VME device drivers bind on top of it.
> 
> Crazy probably equates to not portable across different VME bridges

?? Crazy means crazy. ftrace is crazy, linux-rt is crazy. And
they're great.

> , so no I don't agree. I'm in favour of providing as much flexibility to VME device
> driver authors as possible, without impacting the flexibility of the user to
> use the drivers on top of different VME bridges.

This is nonsense.

> > IMHO in order to make sure we're on
> > the right track we must look at other bus drivers. And these
> > other drivers just keep things simple and stupid, which is
> > flexible, safe and "Obviously Correct(tm)".
> 
> Though I don't think the approach you are advocating is simple for the VME
> device driver writer (new style PCI drivers don't as a rule directly manage
> refcounting, in the same way your approach would add complexity for the
> individual VME device drivers); it's not safe (I deem it unsafe to expect
> every VME device driver writer to manage the refcounting in their drivers
> explicitly, just as it appears is the case for PCI devices) and as a result
> not "Obviously Correct(tm)".

By your definition there are lots of drivers in the kernel
that are unsafe..

I'm tired of your non-arguments. I'm just trying to persuade you
to do what everyone else is doing, with technical reasons. To me
(and to everybody else in this list, I'd imagine) refcounting
should be explicit. You're going against what I perceive are
well-established pratices in the kernel. I can't understand it.

		Emilio

