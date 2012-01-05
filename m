Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab2AEIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 03:43:56 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:39201 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab2AEInz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 03:43:55 -0500
Message-ID: <a2507aff2913b402cfb2d3e2a0bb887a.squirrel@webmail.sf-mail.de>
In-Reply-To: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
References: <1325721002-6094-1-git-send-email-yinghai@kernel.org>
Date: Thu, 5 Jan 2012 09:43:51 +0100
Subject: Re: [PATCH] PCI: Increase resource array mask bit size in
 pcim_iomap_regions()
From: "Rolf Eike Beer" <eike-kernel@sf-tec.de>
To: "Yinghai Lu" <yinghai@kernel.org>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, "Yinghai Lu" <yinghai@kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> DEVICE_COUNT_RESOURCE will be bigger than 16 when SRIOV supported is
> enabled.
>
> Let them pass with int just like pci_enable_resources().
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> ---
>  include/linux/pci.h |    6 +++---
>  lib/devres.c        |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> Index: linux-2.6/include/linux/pci.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pci.h
> +++ linux-2.6/include/linux/pci.h
> @@ -1433,10 +1433,10 @@ static inline void pci_fixup_device(enum
>  void __iomem *pcim_iomap(struct pci_dev *pdev, int bar, unsigned long
> maxlen);
>  void pcim_iounmap(struct pci_dev *pdev, void __iomem *addr);
>  void __iomem * const *pcim_iomap_table(struct pci_dev *pdev);
> -int pcim_iomap_regions(struct pci_dev *pdev, u16 mask, const char *name);
> -int pcim_iomap_regions_request_all(struct pci_dev *pdev, u16 mask,
> +int pcim_iomap_regions(struct pci_dev *pdev, int mask, const char *name);
> +int pcim_iomap_regions_request_all(struct pci_dev *pdev, int mask,
>  				   const char *name);
[...]

You are switching from unsigned to signed here, is this intentional? In my
feeling such masks should end up in an unsigned int, no?

Eike
