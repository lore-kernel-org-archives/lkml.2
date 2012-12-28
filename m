Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab2L1Hp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 02:45:29 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:65036 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab2L1Hp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 02:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <1356679902-4266-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1356679902-4266-1-git-send-email-linfeng@cn.fujitsu.com>
Date: Thu, 27 Dec 2012 23:45:24 -0800
X-Google-Sender-Auth: 3Q7io36bl_-nUMvA_HQbYVtkO4k
Message-ID: <CAE9FiQU1YM32pb+iGJHj1m3W-nGUbHh5f8Qkx5bRsfptgGParw@mail.gmail.com>
Subject: Re: [PATCH] pci: remove redundant function calls in pci_reassigndev_resource_alignment()
From: Yinghai Lu <yinghai@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2012 at 11:31 PM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
> pci_reassigndev_resource_alignment() potentially calls
> pci_specified_resource_alignment() twice, which is redundant.
>
> pci_is_reassigndev() is only called in pci_reassigndev_resource_alignment(),
> and from sematic/functionality aspects pci_specified_resource_alignment() is
> sufficient to substitute, so also make some cleanup.
>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/pci.c |   16 ++--------------
>  1 files changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 5cb5820..789f401 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -3766,18 +3766,6 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
>         return align;
>  }
>
> -/**
> - * pci_is_reassigndev - check if specified PCI is target device to reassign
> - * @dev: the PCI device to check
> - *
> - * RETURNS: non-zero for PCI device is a target device to reassign,
> - *          or zero is not.
> - */
> -int pci_is_reassigndev(struct pci_dev *dev)
> -{
> -       return (pci_specified_resource_alignment(dev) != 0);
> -}
> -
>  /*
>   * This function disables memory decoding and releases memory resources
>   * of the device specified by kernel's boot parameter 'pci=resource_alignment='.
> @@ -3792,7 +3780,8 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>         resource_size_t align, size;
>         u16 command;
>
> -       if (!pci_is_reassigndev(dev))
> +       align = pci_specified_resource_alignment(dev);
> +       if (!align)
>                 return;
>
>         if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL &&
> @@ -3808,7 +3797,6 @@ void pci_reassigndev_resource_alignment(struct pci_dev *dev)
>         command &= ~PCI_COMMAND_MEMORY;
>         pci_write_config_word(dev, PCI_COMMAND, command);
>
> -       align = pci_specified_resource_alignment(dev);
>         for (i = 0; i < PCI_BRIDGE_RESOURCES; i++) {
>                 r = &dev->resource[i];
>                 if (!(r->flags & IORESOURCE_MEM))
> --
> 1.7.1
>

looks the same as the one that i posted 6 months ago.

http://copilotco.com/mail-archives/linux-kernel.2012/msg18498.html

Yinghai
