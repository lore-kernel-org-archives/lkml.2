Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab2LKAnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:43:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53616 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2LKAnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:43:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Tue, 11 Dec 2012 01:48:52 +0100
Message-ID: <1505143.RC4l5yPqAp@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQVgJUzDYRWzW5gCK9WwwAzQthXs++JnfOuxVzo-0KSqxQ@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <3585743.RAy43NB8MZ@vostro.rjw.lan> <CAE9FiQVgJUzDYRWzW5gCK9WwwAzQthXs++JnfOuxVzo-0KSqxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 03:22:48 PM Yinghai Lu wrote:
> On Mon, Dec 10, 2012 at 2:47 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, December 10, 2012 09:07:06 AM Yinghai Lu wrote:
> >> On Mon, Dec 10, 2012 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > On Sunday, December 09, 2012 09:34:42 PM Yinghai Lu wrote:
> >> >>
> >> >> Can we expand the BUS_ADD_* concept to other devices instead of just
> >> >> acpi_device?
> >> >>
> >> >> aka we should let struct device has this add_type field.
> >> >
> >> > Having done that in ACPI to cover our use case here, we can try to move it
> >> > into struct device if there are use cases beyond ACPI that can't be covered
> >> > by using deferred driver probing.
> >>
> >> pci device for hotplug have same problem. need to delay driver attach
> >> for them too.
> >
> > OK, I'll take a look.  Any pointers to speed that up?
> >
> >> also BUS_ADD_MATCH and BUS_ADD_START are duplicated.
> >
> > Not at the moment, they do different things as code goes.
> 
> I do think that is same problem which is in the driver/base core.
> 
> it should support delay loading driver for the hotplug case at the first point.
> that is reason that .start is introduced for acpi driver..to workround
> the problem
> in driver core.

OK, but let's eliminate .start() first and then go make changes to the
driver core.  That is, let's take one step at a time. :-)

> >> old add are separated to adding all devices to tree and then matching
> >> work to load the drivers.
> >>
> >> so _START is not needed anymore, only user.start in pci_root driver
> >> should be removed.
> >> code in .start could be moved .add without problem.
> >
> > Yes, I'm going to do that as the next step.  I didn't want this particular
> 
> after you remove that .start, that will the same as my two patches.
> except that you patches toggle that per-device add_type for every device.
> 
> and my patches is only toggle that per device drivers_autoprobe for
> hot-add devices.

I'm not 100% sure of that, but quite likely that's the case.  I'd like to avoid
special-casing hotplug in any way, if possible.  Also, I have other reasons to
do it for all devices (like the resources management for one example).

> > patchset to grow too big.  I'll post another one on top of it if people
> > don't have problems with this one.
> 
> yesterday, I replace my two acpi driver delay loading patches with your patches.
> 
> during pci root bus hot remove/add test, got the panic...

I don't see what the reason may be at the moment, it would be good to get more
info (like a screenshot of the panic).

> did not have time to look at it yet.

OK

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
