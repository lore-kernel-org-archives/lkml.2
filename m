Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2LRWzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:55:31 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37045 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab2LRWz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:55:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects from probing ACPI drivers
Date: Wed, 19 Dec 2012 00:00:40 +0100
Message-ID: <4447450.z46Q2xYLQX@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1355868912.18964.381.camel@misato.fc.hp.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <3027479.MToB281uxK@vostro.rjw.lan> <1355868912.18964.381.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 18, 2012 03:15:12 PM Toshi Kani wrote:
> On Tue, 2012-12-18 at 22:57 +0100, Rafael J. Wysocki wrote:
> > On Tuesday, December 18, 2012 09:10:41 AM Toshi Kani wrote:
> > > On Tue, 2012-12-18 at 02:48 +0100, Rafael J. Wysocki wrote:
>  :
> > > We need to decide which module is responsible for calling .bind().  I
> > > think it should be the ACPI scan module, not the ACPI PCI root bridge
> > > driver, because:
> > >  - bind() needs to be called when _ADR device is added.  The ACPI scan
> > > module can scan any devices, while the PCI root driver can only scan
> > > when it is added.
> > >  - acpi_bus_remove() calls unbind() at hot-remove.  The same module
> > > should be responsible for both bind() and unbind() handling.
> > >  - It is cleaner to keep struct acpi_device_ops interface to be called
> > > by the ACPI core.
> > 
> > I agree with that. :-)
> > 
> > Moreover, I don't think we need acpi_pci_bind() and acpi_pci_unbind() at all.
> > 
> > > So, I would propose the following changes.
> > > 
> > >  - Move the acpi_hot_add_bind() call back to the original place after
> > > the device_attach() call.
> > >  - Rename the name of acpi_hot_add_bind() to something like
> > > acpi_bind_adr_device() since it is no longer hot-add only (and is
> > > specific to _ADR devices).
> > >  - Create its pair function, acpi_unbind_adr_device(), which is called
> > > from acpi_bus_remove().  When a constructor interface is introduced, its
> > > destructor should be introduced as well. 
> > >  - Remove the binding procedure from acpi_pci_root_add().  This should
> > > be done in patch [2/6].
> > 
> > Well, what about moving the code from acpi_pci_bind()/acpi_pci_unbind()
> > somewhere else and removing those things altogether?
> 
> Sounds nice.  It will be bonus point if you can do that. :-)

I think I can, but I need a few more patches on top of what I've already posted
to do that.

I think that https://patchwork.kernel.org/patch/1889821/ and
https://patchwork.kernel.org/patch/1884701/ can stay as they are, since there's
some material on top of them already and I'll cut the new patches on top of all
that.  I'll repost the whole series some time later this week, stay tuned. :-)

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
