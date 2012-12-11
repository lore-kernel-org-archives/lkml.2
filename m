Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab2LKA5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 19:57:15 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53666 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab2LKA5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 19:57:14 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Tue, 11 Dec 2012 02:02:14 +0100
Message-ID: <38722368.Fl8pJoLSRi@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQWZ8WaAJm8ayU+woVRqNLdSRtPS4=gpsrJovmzrUG6FNw@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <54207850.t6nmM83CdM@vostro.rjw.lan> <CAE9FiQWZ8WaAJm8ayU+woVRqNLdSRtPS4=gpsrJovmzrUG6FNw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 10, 2012 03:14:32 PM Yinghai Lu wrote:
> On Mon, Dec 10, 2012 at 3:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, December 10, 2012 11:47:27 PM Rafael J. Wysocki wrote:
> >> On Monday, December 10, 2012 09:07:06 AM Yinghai Lu wrote:
> >> > On Mon, Dec 10, 2012 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> > > On Sunday, December 09, 2012 09:34:42 PM Yinghai Lu wrote:
> >> > >>
> >> > >> Can we expand the BUS_ADD_* concept to other devices instead of just
> >> > >> acpi_device?
> >> > >>
> >> > >> aka we should let struct device has this add_type field.
> >> > >
> >> > > Having done that in ACPI to cover our use case here, we can try to move it
> >> > > into struct device if there are use cases beyond ACPI that can't be covered
> >> > > by using deferred driver probing.
> >> >
> >> > pci device for hotplug have same problem. need to delay driver attach
> >> > for them too.
> >>
> >> OK, I'll take a look.  Any pointers to speed that up?
> >>
> >> > also BUS_ADD_MATCH and BUS_ADD_START are duplicated.
> >>
> >> Not at the moment, they do different things as code goes.
> >>
> >> > old add are separated to adding all devices to tree and then matching
> >> > work to load the drivers.
> >> >
> >> > so _START is not needed anymore, only user.start in pci_root driver
> >> > should be removed.
> >> > code in .start could be moved .add without problem.
> >>
> >> Yes, I'm going to do that as the next step.  I didn't want this particular
> >> patchset to grow too big.  I'll post another one on top of it if people
> >> don't have problems with this one.
> >
> > By the way, can you please remind me where you wanted to put the
> > pci_bus_add_devices() and why?
> >
> 
> please check my for-pci-next branch at
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-next
> 
> that includes delay loading acpi driver and pci driver.
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=8c031eabbdc83dd4d93933b82d96b55d038bcb64
>  PCI: prepare to use device drivers_autoprobe to delay attach drivers
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=40a12dc8942a8ed02bfbf75ee1ffbfbdf1511b45
> PCI: Use device_add for device and bus early
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=8af9b4c250091c30afedeb2e7f14fca06997c811
> ACPI: add drivers_autoprobe in struct acpi_device
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=ae498e157e9dc8794932562b2f885ddc3a1a229a
>  ACPI: use device drivers_autoprobe to delay loading acpi drivers
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=6bee785b563a0b0e311e188321b1160593d5e6ee
>  PCI, ACPI: Remove not used acpi_pci_root_start()
> 
> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=f467a1cd18a07a250be8527b94612fd4a654fbd1
> ACPI: remove acpi_op_start workaround

OK, thanks for the pointers.  I actually see more differences between our
patchsets.  For one example, you seem to have left the parent->ops.bind()
stuff in acpi_add_single_object() which calls it even drivers_autoprobe is
set.  Is that the case, or am I missing anything?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
