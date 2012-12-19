Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2LSB5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:57:23 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48266 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab2LSB5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:57:22 -0500
MIME-Version: 1.0
In-Reply-To: <3573149.O0Vu1dNrT9@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	<1355847041.18964.369.camel@misato.fc.hp.com>
	<CAE9FiQV-GDRd1iapMwy4j4mBChRpEm-9ANHg6BTdyiTd-5Bf8A@mail.gmail.com>
	<3573149.O0Vu1dNrT9@vostro.rjw.lan>
Date: Tue, 18 Dec 2012 17:57:20 -0800
X-Google-Sender-Auth: tZ0MAhtjxj1hNKhWTMYo-kdQl40
Message-ID: <CAE9FiQV16BO-gC7Etm93OOG3tVY1Av614jZoZb_8cHeZ3oUq8A@mail.gmail.com>
Subject: Re: [PATCH rev.2 1/6] ACPI: Separate adding ACPI device objects from
 probing ACPI drivers
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 2:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> i think we should put jiang four patches before Rafael's patches.
>>
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=shortlog;h=refs/heads/for-pci-jiang-hotplug
>
> Actually, I have something more radical than that in mind. :-)
>
> Namely, we don't need to call the wakeup-related stuff from acpi_pci_bind() and
> acpi_pci_unbind().  It's only there, because I did't find a better place for it
> when I added it.
>
> If we can set the ACPI handles of PCI devices in pci_scan_device(), which isn't
> too difficult to do (I actually have a patch for that and it's not too invasive),
> we can easily move the wakeup enabling stuff to pci_pm_init() and wakeup
> disabling somewhere near pci_release_capabilities().

good, let's see how acpi handles could be be passed to pci devices.

Yinghai
