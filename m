Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2ENVVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:21:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48905 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab2ENVVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:21:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120511225636.30496.26907.stgit@bling.home>
References: <20120511222148.30496.68571.stgit@bling.home> <20120511225636.30496.26907.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 14 May 2012 15:20:40 -0600
Message-ID: <CAErSpo6-Oy6eTgUBNRfM3HwFSLpDXJt3K1N0DKFpyYsNiSxwRQ@mail.gmail.com>
Subject: Re: [PATCH 10/13] pci: export pci_user functions for use by other drivers
To: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, aik@ozlabs.ru, david@gibson.dropbear.id.au,
        joerg.roedel@amd.com, dwmw2@infradead.org, chrisw@sous-sol.org,
        agraf@suse.de, benve@cisco.com, aafabbri@cisco.com,
        B08248@freescale.com, B07421@freescale.com, avi@redhat.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index dc25da3..b437225 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -770,6 +770,14 @@ static inline int pci_write_config_dword(const struct pci_dev *dev, int where,
>        return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
>  }
>
> +/* user-space driven config access */
> +extern int pci_user_read_config_byte(struct pci_dev *dev, int where, u8 *val);
> +extern int pci_user_read_config_word(struct pci_dev *dev, int where, u16 *val);
> +extern int pci_user_read_config_dword(struct pci_dev *dev, int where, u32 *val);
> +extern int pci_user_write_config_byte(struct pci_dev *dev, int where, u8 val);
> +extern int pci_user_write_config_word(struct pci_dev *dev, int where, u16 val);
> +extern int pci_user_write_config_dword(struct pci_dev *dev, int where, u32 val);

If you repost this, can you remove the externs when you move these
declarations?  I know the file's currently a random mix, but we might
as well make a tiny improvement.

Looks fine to me otherwise, and if you don't have any other reason to
update this series, don't worry about it.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

>  int __must_check pci_enable_device(struct pci_dev *dev);
>  int __must_check pci_enable_device_io(struct pci_dev *dev);
>  int __must_check pci_enable_device_mem(struct pci_dev *dev);
>
