Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0LGAsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:48:38 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53578 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LGAsh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 19:48:37 -0500
Date: Mon, 6 Dec 2010 19:48:44 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Airlie <airlied@redhat.com>
Cc: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] Utilize the PCI API in the AGP framework.
Message-ID: <20101207004844.GA31478@dumpdata.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
 <1291680126.8232.5.camel@clockmaker-el6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291680126.8232.5.camel@clockmaker-el6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 07, 2010 at 10:02:06AM +1000, Dave Airlie wrote:
> On Mon, 2010-12-06 at 18:24 -0500, Konrad Rzeszutek Wilk wrote:
> > Attached is a set of RFC patches that make it possible for AGP graphic drivers to
> > work under Xen. The major problem that Linux kernel has when running under Xen
> > is that the usage of "virt_to_phys(x) >> PAGE_SIZE" to get the DMA address is not
> > applicable. That is due to the fact that the PFN value is not the real Machine
> > Frame Number (MFN), hence virt_to_phys(x) >> PAGE_SIZE ends up pointing to a
> > random physical address. But if you use the PCI API, then the DMA (bus) address
> > returned is a valid MFN.
> 
> Can I ask you to go back a step and address what the use case for all of
> this is, the patch description doesn't address why anyone cares about
> AGP in 2010, esp with Xen. Virtualising hw  drivers for the sake of it
> is all well and good, but since most of these drivers are for really
> legacy systems I can't imagine we are going to see a lot of regression
> testing before they hit distros like Debian two years from now, though
> maybe Gentoo might pick up some, (is anyone even running IA64?).

Hey Dave,
Thank you for you quick reply and brief look at the code. When I wrote
this code a similar thought went through my head, and around that
time three bugs from Debian (#601341, #602418 and #604096) asked what
is the the status of making AGP work with Xen. I've asked the folks
on the bugs to provide input on your question. In regards to regressions
I've a lot of these machines so I can definitly test them for
regressions (my thought was to run the OpenArena, TuxRace, and watch
some flash - is that a good enough test or should I expand it?)
But obviously I don't have all of them so yeah something might break.

> 
> I can maybe imagine the Intel GTT being cared about but we've already
> addressed the issues in it from what I can see.

Definitly for the new hardware.
> 
> Also the X server use case is still possibly valid for a lot of the
> systems here, its userspace ABI so it can't just end up broken. The move

Right. That would mean testing the MGA, SiS, VIA, and whatever else in the 
drivers/gpu/drm/ directory with Xserver. Would the latest Xorg (1.8) do?

> to TTM/DRM being the main user didn't suddenly remove the use of the X
> server case on older systems which don't have a TTM/DRM layer.

Yup. I've some patches for that too, but figured it would make sense
to get input first on this set. Let me post them shortly as they can
be used independently of this patchset.
> 
> Other than that the idea seems sane, I just hate having to upgrade large
> parts of the subsystem without some reasonable justification that

Naturally.
> someone out there is going to use it. If it allows some major cleanup
> else where that would also be a possibly good justification.
> 
> Dave.
> 
> 
