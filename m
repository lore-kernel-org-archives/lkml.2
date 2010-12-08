Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0LHT4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:56:19 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17298 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0LHT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:56:18 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: resource map sanity check conflict
Date: Wed, 8 Dec 2010 12:56:06 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        abelay@mit.edu, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Renninger <trenn@suse.de>
References: <4CED14C1.4050703@suse.cz> <4CFD44DD.3070901@gmail.com> <201012061334.57246.bjorn.helgaas@hp.com>
In-Reply-To: <201012061334.57246.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012081256.06513.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 06, 2010 01:34:56 pm Bjorn Helgaas wrote:
> On Monday, December 06, 2010 01:17:33 pm Jiri Slaby wrote:
> > On 11/24/2010 08:22 PM, Bjorn Helgaas wrote:
> > > On Wednesday, November 24, 2010 06:36:01 am Jiri Slaby wrote:
...
> > >> pnp 00:0a: [mem 0xfed40000-0xfed44fff]
> > >> pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
> > >> ...
> > >> resource map sanity check conflict: 0xfed40000 0xfed44fff 0xfed44000
...
> > > Yes, this is related to the PCI resource changes I made recently.
> > > We used to allocate PCI resources from low addresses first and work
> > > upwards, and now we do the reverse.  So in 2.6.36, the "Intel Flush
> > > Page" was probably allocated low in the [mem 0x7e000000-0xfebfffff]
> > > window, but now we put it in the [mem 0xfed40000-0xfed4bfff] window:
> > > 
> > >   pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
> > >   pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
> > > 
> > > I think the problem is that we ignore most of what ACPI tells us
> > > about motherboard device resource usage.  We do have the "system"
> > > driver, which reserves resources used by PNP0c01 and PNP0c02 devices,
> > > but we don't do anything about other devices like the ATM1200/PNP0c31
> > > device which, in your case, is using some of the space in that
> > > [mem 0xfed40000-0xfed4bfff] host bridge window.

> > I created the bko entry some time ago:
> > https://bugzilla.kernel.org/show_bug.cgi?id=23802

I have a patch here for testing:

  https://bugzilla.kernel.org/attachment.cgi?id=39262

Bjorn
