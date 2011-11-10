Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933839Ab1KJIyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933715Ab1KJIyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:54:38 -0500
Date: Thu, 10 Nov 2011 10:55:36 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: Re: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111110085536.GA32171@redhat.com>
References: <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
 <20111109195901.GA28155@redhat.com>
 <1320870287.3730.6.camel@lappy>
 <20111109205208.GA28599@redhat.com>
 <1320872248.3730.11.camel@lappy>
 <20111109211445.GC28599@redhat.com>
 <1320873236.3730.13.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320873236.3730.13.camel@lappy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 09, 2011 at 11:13:56PM +0200, Sasha Levin wrote:
> On Wed, 2011-11-09 at 23:14 +0200, Michael S. Tsirkin wrote:
> > On Wed, Nov 09, 2011 at 10:57:28PM +0200, Sasha Levin wrote:
> > > On Wed, 2011-11-09 at 22:52 +0200, Michael S. Tsirkin wrote:
> > > > On Wed, Nov 09, 2011 at 10:24:47PM +0200, Sasha Levin wrote:
> > > > > On Wed, 2011-11-09 at 21:59 +0200, Michael S. Tsirkin wrote:
> > > > > 
> > > > > [snip]
> > > > > 
> > > > > > +\begin_layout Enumerate
> > > > > > +Reset the device.
> > > > > > + This is not required on initial start up.
> > > > > > +\end_layout
> > > > > > +
> > > > > > +\begin_layout Enumerate
> > > > > > +The ACKNOWLEDGE status bit is set: we have noticed the device.
> > > > > > +\end_layout
> > > > > > +
> > > > > > +\begin_layout Enumerate
> > > > > > +The DRIVER status bit is set: we know how to drive the device.
> > > > > > +\end_layout
> > > > > > +
> > > > > > +\begin_layout Enumerate
> > > > > > +
> > > > > > +\change_inserted 1986246365 1320838089
> > > > > > +PCI capability list scan, detecting virtio configuration layout using Virtio
> > > > > > + Structure PCI capabilities.
> > > > > 
> > > > > Does the legacy space always gets mapped from BAR0?
> > > > > 
> > > > > If yes,
> > > > 
> > > > Yes and this is repeated in several places. Not clear? How can this
> > > > be made clearer?
> > > 
> > > Do you mean comments such as "For backwards compatibility, devices
> > > should also present legacy configuration space in the first I/O region
> > > of the PCI device"? What I understood from it is that the device should
> > > have a legacy config in case it's used with an older guest, but I didn't
> > > understand from it that the legacy config will be used even if new
> > > layout is present.
> > 
> > Yes, this is what I meant. New guest is required to use the new space
> > and not the legacy one. So you dont need a legacy space for the at all.
> > But practically, we'll need to support old guests for a long while.
> > 
> > > > > It'll be a bit harder deprecating it in the future.
> > > > 
> > > > Harder than ... what ?
> > > 
> > > Harder than allowing devices not to present it at all if new layout
> > > config is used.
> > 
> > Yes, it's allowed if you know you have a new guest. It says
> > explicitly that drivers are required to use new capabilities
> > is they are there.
> > 
> > > Right now the simple implementation is to use MMIO for
> > > config and device specific, and let it fallback to legacy for ISR and
> > > notifications (and therefore, this is probably how everybody will
> > > implement it), which means that when you do want to deprecate legacy,
> > > there will be extra work to be done then, instead of doing it now.
> > 
> > If hypervisors don't implement the new layout then drivers will
> > have to keep supporting the old one. I don't think we can do
> > much about that.
> > 
> > > > IMO there's no way to put legacy anywhere except the first BAR
> > > > without breaking existing guests.
> > > 
> > > It's not about where we put legacy, it's about how easy it is to drop
> > > legacy entirely.
> > 
> > We can only do this after all guests and hypervisors are updated. When
> > they are, we can drop legacy from drivers and hypervisors, and
> > I don't see a way to make it easier.
> 
> Well, in that case, why does the PCI cap probing is #4 in the device
> init list? Shouldn't we getting the layout and mapping it before we
> write to the status byte?

True, this is actually how it's done in the driver.
Good catch, I'll correct the text, thanks.

> -- 
> 
> Sasha.
