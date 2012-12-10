Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab2LJOl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:41:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52267 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2LJOlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:41:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
Date: Mon, 10 Dec 2012 15:46:55 +0100
Message-ID: <2637774.lmuX5P2qQX@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
In-Reply-To: <CAE9FiQWxoWubagm4gj81YgMeqyEZgpT47ROAfjmXSmoaTn-Yig@mail.gmail.com>
References: <8498184.VilrUmatxI@vostro.rjw.lan> <2097693.II1PNyeFLY@vostro.rjw.lan> <CAE9FiQWxoWubagm4gj81YgMeqyEZgpT47ROAfjmXSmoaTn-Yig@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 09, 2012 09:34:42 PM Yinghai Lu wrote:
> On Sun, Dec 9, 2012 at 3:03 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Notice that one member of struct acpi_bus_ops, acpi_op_add, is not
> > used anywhere any more and the relationship between its remaining
> > members, acpi_op_match and acpi_op_start, is such that it doesn't
> > make sense to set the latter without setting the former at the same
> > time.  Therefore, replace struct acpi_bus_ops with new a enum type,
> > enum acpi_bus_add_type, with three values, ACPI_BUS_ADD_BASIC,
> > ACPI_BUS_ADD_MATCH, ACPI_BUS_ADD_START, corresponding to
> > both acpi_op_match and acpi_op_start unset, acpi_op_match set and
> > acpi_op_start unset, and both acpi_op_match and acpi_op_start set,
> > respectively.
> >
> 
> Can we expand the BUS_ADD_* concept to other devices instead of just
> acpi_device?
> 
> aka we should let struct device has this add_type field.

Having done that in ACPI to cover our use case here, we can try to move it
into struct device if there are use cases beyond ACPI that can't be covered
by using deferred driver probing.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
