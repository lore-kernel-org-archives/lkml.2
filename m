Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab1CKOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:46:42 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12037 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab1CKOqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:46:38 -0500
X-IronPort-AV: E=Sophos;i="4.62,303,1297036800"; 
   d="scan'208";a="4746807"
Subject: Re: [Xen-devel] Re: [GIT PATCH v2 0/14] xen: events: cleanups +
 ween off nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110311142954.GC4880@dumpdata.com>
References: <1299773279.17339.813.camel@zakaz.uk.xensource.com>
	 <20110310225726.GA2983@dumpdata.com>
	 <1299834774.17339.1799.camel@zakaz.uk.xensource.com>
	 <1299842689.17339.1986.camel@zakaz.uk.xensource.com>
	 <1299850128.17339.2007.camel@zakaz.uk.xensource.com>
	 <20110311142954.GC4880@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 11 Mar 2011 14:46:36 +0000
Message-ID: <1299854796.17339.2068.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 14:29 +0000, Konrad Rzeszutek Wilk wrote:
> > > > > I am having difficulties with passthrough of an USB device. Somehow the
> > > > > irq count is not going up at all (both in dom0 and domU) and it looks to
> > > > > be doing just simple polling. I've rebased the xen-pciback to be on top
> > > > > of your changes and apply cleanly. The whole lot is now in #master
> > > > > 
> > > > > MSI and MSI-X devices work just fine in both Dom0 and DomU case so
> > > > > it is something special with the legacy IRQs. Probably forgot something
> > > > > simple...
> > > > 
> > > > Thanks, I'll take a look. Did you mean "legacy IRQ" as in <16 or as in
> > > > not-MSI(-X)?
> 
> not-MSI(-X) ones. I've this fancy LSI 1030 controller that sits at GSI 46 on this
> SuperMicro board and it is quite confused.
> > > 
> > > Works for me in a PV guest, at least under the second interpretation (I
> > > don't have any useful devices IRQ < 16). This is with your pciback 0.5.
> 
> OK. Let me boot up that machine and see what /proc/interrupts look like. Maybe
> the xen-pciback.hide=() throws a lot of things out of whack.

FWIW I'm using xen-pciback.hide too.

> > > 
> > > I see something like what you describe under HVM, although pciback is
> > > not used in that case. xc_physdev_map_pirq is used but not with
> > > the /sys/.../bdf node AFAICT.
> > > 
> > > More digging required I guess...
> > 
> > If I just pass through the EHCI device it doesn't work. However if I
> > also pass-through the associated UHCI controller then I do see the
> > usb-storage device, interrupts and all. The EHCI controller still
> > doesn't work though. Note that with a PV guest passing-through the EHCI
> > controller by itself does work.
> > 
> > The issue I'm seeing seems to have more to do with accessing the memory
> > mapped BAR than IRQs though:
> 
> > 
> >         ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> >         PHYSDEVOP_map_pirq mapped gsi 46 to pirq 18
> >         xen_allocate_pirq_gsi for gsi 46, pirq 18 "ioapic-level"
> >         xen: --> irq=46, pirq=18
> >         ehci_hcd 0000:00:07.0: PCI INT C -> GSI 46 (level, low) -> IRQ 46
> >         ehci: remapped rsrc 0xf3021000 to c8064000
> 
> <scratch> If you hit the 'i' in the debug console is this 
> BAR visible there? That is f3021?

'i' is irq information not BARs, but FWIW the IRQ associated with this
H/W appears to be mapped correctly.

I couldn't find another debug key which looked like it contained the
sort of thing you meant.

Ian.

