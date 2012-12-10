Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab2LJRHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:07:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35048 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab2LJRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <2637774.lmuX5P2qQX@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	<2097693.II1PNyeFLY@vostro.rjw.lan>
	<CAE9FiQWxoWubagm4gj81YgMeqyEZgpT47ROAfjmXSmoaTn-Yig@mail.gmail.com>
	<2637774.lmuX5P2qQX@vostro.rjw.lan>
Date: Mon, 10 Dec 2012 09:07:06 -0800
X-Google-Sender-Auth: N0mGLbYil4p4TabwWnHnXSXYcCc
Message-ID: <CAE9FiQXsBC-CY4KqKkaAXx3sYLVWJOaaKGkg_kChb7ry_7Sq8Q@mail.gmail.com>
Subject: Re: [PATCH 5/6] ACPI: Replace struct acpi_bus_ops with enum type
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        linux-pci@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 6:46 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, December 09, 2012 09:34:42 PM Yinghai Lu wrote:
>>
>> Can we expand the BUS_ADD_* concept to other devices instead of just
>> acpi_device?
>>
>> aka we should let struct device has this add_type field.
>
> Having done that in ACPI to cover our use case here, we can try to move it
> into struct device if there are use cases beyond ACPI that can't be covered
> by using deferred driver probing.

pci device for hotplug have same problem. need to delay driver attach
for them too.

also BUS_ADD_MATCH and BUS_ADD_START are duplicated.

old add are separated to adding all devices to tree and then matching
work to load the drivers.

so _START is not needed anymore, only user.start in pci_root driver
should be removed.
code in .start could be moved .add without problem.
