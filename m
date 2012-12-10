Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2LJXEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:04:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53409 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2LJXEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:04:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Tue, 11 Dec 2012 00:09:22 +0100
Message-ID: <54207850.t6nmM83CdM@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <3585743.RAy43NB8MZ@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <CAE9FiQXsBC-CY4KqKkaAXx3sYLVWJOaaKGkg_kChb7ry_7Sq8Q@mail.gmail.com> <3585743.RAy43NB8MZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 11:47:27 PM Rafael J. Wysocki wrote:
> On Monday, December 10, 2012 09:07:06 AM Yinghai Lu wrote:
> > On Mon, Dec 10, 2012 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Sunday, December 09, 2012 09:34:42 PM Yinghai Lu wrote:
> > >>
> > >> Can we expand the BUS_ADD_* concept to other devices instead of just
> > >> acpi_device?
> > >>
> > >> aka we should let struct device has this add_type field.
> > >
> > > Having done that in ACPI to cover our use case here, we can try to move it
> > > into struct device if there are use cases beyond ACPI that can't be covered
> > > by using deferred driver probing.
> > 
> > pci device for hotplug have same problem. need to delay driver attach
> > for them too.
> 
> OK, I'll take a look.  Any pointers to speed that up?
> 
> > also BUS_ADD_MATCH and BUS_ADD_START are duplicated.
> 
> Not at the moment, they do different things as code goes.
> 
> > old add are separated to adding all devices to tree and then matching
> > work to load the drivers.
> > 
> > so _START is not needed anymore, only user.start in pci_root driver
> > should be removed.
> > code in .start could be moved .add without problem.
> 
> Yes, I'm going to do that as the next step.  I didn't want this particular
> patchset to grow too big.  I'll post another one on top of it if people
> don't have problems with this one.

By the way, can you please remind me where you wanted to put the
pci_bus_add_devices() and why?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
