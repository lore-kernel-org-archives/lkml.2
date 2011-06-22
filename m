Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab1FVWWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:22:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51513 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758297Ab1FVWWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:22:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: [Update][PATCH 7/8] PM / Domains: System-wide transitions support for generic domains (v3)
Date: Thu, 23 Jun 2011 00:22:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Magnus Damm <magnus.damm@gmail.com>, Paul Walmsley <paul@pwsan.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl> <201106230016.46704.rjw@sisk.pl> <871uyljys6.fsf@ti.com>
In-Reply-To: <871uyljys6.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106230022.56462.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Wednesday, June 22, 2011, Kevin Hilman wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> > From: Rafael J. Wysocki <rjw@sisk.pl>
> >> >
> >> > Make generic PM domains support system-wide power transitions
> >> > (system suspend and hibernation).  Add suspend, resume, freeze, thaw,
> >> > poweroff and restore callbacks to be associated with struct
> >> > generic_pm_domain objects and make pm_genpd_init() use them as
> >> > appropriate.
> >> >
> >> > The new callbacks do nothing for devices belonging to power domains
> >> > that were powered down at run time (before the transition).  
> >> 
> >> Great, this is the approach I prefer too, but...
> >> 
> >> Now I'm confused.  Leaving runtime suspended devices alone is what I was
> >> doing in my subsystem but was told not to.  According to
> >> 
> >>     http://www.mail-archive.com/linux-omap@vger.kernel.org/msg50690.html
> >> 
> >> "it's generally agreed that _all_ devices should return to full 
> >> power during system resume -- even if they were runtime suspended 
> >> before the system sleep."
> >
> > Well, let's say this part of the documentation is slightly outdated.
> >
> > It basically refers to the model in which system suspend is a separate global
> > hardware or firmware operation, so the state of devices may be changed by the
> > BIOS or whatever takes over control in the meantime.  In that case the kernel
> > has to ensure that the states of devices are consistent with what it thinks
> > about them and the simplest way to achieve that is to put the devices to
> > full power during resume (and back to low power if that's desirable).
> >
> > However, in the case of the systems this patchset is intended for system
> > suspend is achieved by putting various hardware components into low-power
> > states directly in a coordinated way and the system sleep state effectively
> > follows from the low-power states the hardware components end up in.  The
> > system is woken up from this state by an interrupt or another mechanism under
> > the kernel's control.  As a result, the kernel never gives control away, so
> > the state of devices after the resume is precisely known to it.
> > In consequence, it need not ensure that the state of devices is consistent with
> > its view, because it knows that this is the case. :-)
> >
> > So the documentation should be updated to say what hardware model it is
> > referring to.
> 
> Great!   Thanks for the clarification.

No problem, I guess I should update the documentation eventually.

Thanks,
Rafael
