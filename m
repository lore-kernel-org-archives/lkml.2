Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab2IKWDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:03:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38076 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab2IKWD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <1344355862-2726-3-git-send-email-jiang.liu@huawei.com>
References: <1344355862-2726-1-git-send-email-jiang.liu@huawei.com> <1344355862-2726-3-git-send-email-jiang.liu@huawei.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Sep 2012 16:03:05 -0600
Message-ID: <CAErSpo7oXFGARWS+M=_7_R_4Hw6j5pufRbaNKtwTr5BT-_xeAA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 02/22] PCI: trivial cleanups for drivers/pci/remove.c
To: Jiang Liu <liuj97@gmail.com>
Cc: Don Dutile <ddutile@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Yijing Wang <wangyijing@huawei.com>, Xinwei Hu <huxinwei@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 7, 2012 at 10:10 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Trivial cleanups for drivers/pci/remove.c:
> 1) move the comment for pci_stop_and_remove_bus_device() to the right place
> 2) rename __pci_remove_behind_bridge() to pci_remove_behind_bridge()

This seems fine, but I think my pci/bjorn-cleanup-remove branch subsumes it.

> Signed-off-by: Jiang Liu <liuj97@gmail.com>
> ---
>  drivers/pci/remove.c |   33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> index 04a4861..33b6318 100644
> --- a/drivers/pci/remove.c
> +++ b/drivers/pci/remove.c
> @@ -78,25 +78,14 @@ void pci_remove_bus(struct pci_bus *pci_bus)
>  }
>  EXPORT_SYMBOL(pci_remove_bus);
>
> -static void __pci_remove_behind_bridge(struct pci_dev *dev);
> -/**
> - * pci_stop_and_remove_bus_device - remove a PCI device and any children
> - * @dev: the device to remove
> - *
> - * Remove a PCI device from the device lists, informing the drivers
> - * that the device has been removed.  We also remove any subordinate
> - * buses and children in a depth-first manner.
> - *
> - * For each device we remove, delete the device structure from the
> - * device lists, remove the /proc entry, and notify userspace
> - * (/sbin/hotplug).
> - */
> +static void pci_remove_behind_bridge(struct pci_dev *dev);
> +
>  void __pci_remove_bus_device(struct pci_dev *dev)
>  {
>         if (dev->subordinate) {
>                 struct pci_bus *b = dev->subordinate;
>
> -               __pci_remove_behind_bridge(dev);
> +               pci_remove_behind_bridge(dev);
>                 pci_remove_bus(b);
>                 dev->subordinate = NULL;
>         }
> @@ -105,13 +94,25 @@ void __pci_remove_bus_device(struct pci_dev *dev)
>  }
>  EXPORT_SYMBOL(__pci_remove_bus_device);
>
> +/**
> + * pci_stop_and_remove_bus_device - remove a PCI device and any children
> + * @dev: the device to remove
> + *
> + * Remove a PCI device from the device lists, informing the drivers
> + * that the device has been removed.  We also remove any subordinate
> + * buses and children in a depth-first manner.
> + *
> + * For each device we remove, delete the device structure from the
> + * device lists, remove the /proc entry, and notify userspace
> + * (/sbin/hotplug).
> + */
>  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
>  {
>         pci_stop_bus_device(dev);
>         __pci_remove_bus_device(dev);
>  }
>
> -static void __pci_remove_behind_bridge(struct pci_dev *dev)
> +static void pci_remove_behind_bridge(struct pci_dev *dev)
>  {
>         struct list_head *l, *n;
>
> @@ -141,7 +142,7 @@ static void pci_stop_behind_bridge(struct pci_dev *dev)
>  void pci_stop_and_remove_behind_bridge(struct pci_dev *dev)
>  {
>         pci_stop_behind_bridge(dev);
> -       __pci_remove_behind_bridge(dev);
> +       pci_remove_behind_bridge(dev);
>  }
>
>  static void pci_stop_bus_devices(struct pci_bus *bus)
> --
> 1.7.9.5
>
