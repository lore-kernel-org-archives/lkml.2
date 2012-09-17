Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab2IQTfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 15:35:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab2IQTfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 15:35:09 -0400
MIME-Version: 1.0
In-Reply-To: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
References: <1346168638-32724-1-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Sep 2012 13:34:46 -0600
Message-ID: <CAErSpo6qSZ3Kgr7rDZt4wMW5nPiGhJBiQyaJPiA7+BY=ttyJLQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Simplify code by using hotplug safe pci_get_domain_bus_and_slot()
To: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Don Dutile <ddutile@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 9:43 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Following code has a race window between pci_find_bus() and pci_get_slot()
> if PCI hotplug operation happens between them which removes the pci_bus.
> So use PCI hotplug safe interface pci_get_domain_bus_and_slot() instead,
> which also reduces code complexity.
>
> struct pci_bus *pci_bus = pci_find_bus(domain, busno);
> struct pci_dev *pci_dev = pci_get_slot(pci_bus, devfn);
>
> Jiang Liu (5):
>   PCI/IA64: simplify code by hotplug safe pci_get_domain_bus_and_slot()
>   PCI/vga: simplify code by hotplug safe pci_get_domain_bus_and_slot()
>   PCI/cpcihp: simplify code by hotplug safe
>     pci_get_domain_bus_and_slot()
>   PCI/IOV: simplify code by hotplug safe pci_get_domain_bus_and_slot()
>   PCI/xen-pcifront: simplify code by hotplug safe
>     pci_get_domain_bus_and_slot()

I applied these to my "next" branch, including the vgaarb and xen bits.  Thanks!

>  arch/ia64/sn/kernel/io_common.c      |    4 +---
>  drivers/gpu/vga/vgaarb.c             |   15 +++------------
>  drivers/pci/hotplug/cpcihp_generic.c |    8 ++------
>  drivers/pci/iov.c                    |    8 ++------
>  drivers/pci/xen-pcifront.c           |   10 ++--------
>  5 files changed, 10 insertions(+), 35 deletions(-)
>
> --
> 1.7.9.5
>
