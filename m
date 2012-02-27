Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2B0XAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:00:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34165 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab2B0XAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:00:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.180.107.67 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWgjSSXQgi=xsK8em4pWtXy5vUq2vtNazX3Hurq2CUmBQ@mail.gmail.com>
References: <1330299202-3838-1-git-send-email-yinghai@kernel.org>
 <1330299202-3838-6-git-send-email-yinghai@kernel.org> <CAErSpo4PMzuPdCZvbYFiQRGjGuMg+KYk0ZxJH0xr-n6AfqBAnA@mail.gmail.com>
 <CAE9FiQUDtJc5uwPXkQ7T7zr8=xa=VnPuQT4Q87SXbynuCHQ2Zg@mail.gmail.com>
 <CAErSpo4pDOZ0FM_OQ7=X2iysfUy6pFyWvY5i7WX=5cdD2Tu9Ew@mail.gmail.com>
 <CAE9FiQUAp6kWT4DZvAKCBGhbGWMp2Q1hz_fuJKD0mS8BYzUb1g@mail.gmail.com>
 <CAErSpo5WUhbiGc6kexRKdwA4F-BqdT-9gZY2HZSaxiPm+ZfUtw@mail.gmail.com> <CAE9FiQWgjSSXQgi=xsK8em4pWtXy5vUq2vtNazX3Hurq2CUmBQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 16:00:15 -0700
Message-ID: <CAErSpo7MFajXaQe52gXdVjaMLRU2Cpcu88QjM+Mw_22bArwF7w@mail.gmail.com>
Subject: Re: [PATCH 5/8] PCI: add generic device into pci_host_bridge struct
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 3:55 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 27, 2012 at 2:24 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>
>>> for every bus will have ->bridge, and that is device pointer. to  pci
>>> bridge dev.
>>>
>>> for root bus, there is not pci bridge for that. So create_root_bus
>>> allocate local dummy one.
>>>
>>> that dummy device will be bus->dev's parent.
>>>
>>> Now pci_host_bridge is added, and it is allocated, so just put the
>>> struct device into that pci_host_bridge.
>>>
>>> and use pci_host_bridge->dev as parent of root bus->dev's parent.
>>
>> What's the device passed in to pci_create_root_bus()?  Why is that
>> different than the root bus dev's parent?
>
> ia64 and x86 doesn't pass that.
>
> arch/ia64/pci/pci.c:    pbus = pci_create_root_bus(NULL, bus,
> &pci_root_ops, controller,
> arch/powerpc/kernel/pci-common.c:       bus =
> pci_create_root_bus(hose->parent, hose->first_busno,
> arch/sparc/kernel/pci.c:        bus = pci_create_root_bus(parent,
> pbm->pci_first_busno, pbm->pci_ops,
> arch/x86/pci/acpi.c:            bus = pci_create_root_bus(NULL,
> busnum, &pci_root_ops, sd,
> drivers/parisc/dino.c:  dino_dev->hba.hba_bus = bus =
> pci_create_root_bus(&dev->dev,
> drivers/parisc/lba_pci.c:               pci_create_root_bus(&dev->dev,
> lba_dev->hba.bus_num.start,
>
> sparc, powerpc, parisc have their local ...
>
> so local hose etc's dev ---> allocated dev ---> root bus's dev
>
> this patch change to
>
> local hose etc's dev ---> allocated host bridge's dev ---> root bus's dev

Why do we have a separate dev for the hose and the root bus's dev?
The hose *is* a PCI host bridge.
