Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab1J2TqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 15:46:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48429 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab1J2TqG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 15:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <1317131836-11822-4-git-send-email-joerg.roedel@amd.com>
References: <1317131836-11822-1-git-send-email-joerg.roedel@amd.com>
	<1317131836-11822-4-git-send-email-joerg.roedel@amd.com>
Date: Sat, 29 Oct 2011 21:36:13 +0200
X-Google-Sender-Auth: 2jWtU1XT6OUaVMkdPp1jO1BBRYc
Message-ID: <CAMuHMdUJU+4n73P6Kc920+ZeJZouCc52QVa1Emanjiiu1kmq-w@mail.gmail.com>
Subject: Re: [PATCH 3/4] PCI: Add implementation for PRI capability
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 15:57, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Implement the necessary functions to handle PRI capabilities
> on PCIe devices. With PRI devices behind an IOMMU can signal
> page fault conditions to software and recover from such
> faults.
>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  drivers/pci/Kconfig      |    9 +++
>  drivers/pci/ats.c        |  167 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci-ats.h  |   42 ++++++++++++
>  include/linux/pci_regs.h |   12 +++
>  4 files changed, 230 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 1d8ce83..fb1e9707 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -85,6 +85,15 @@ config PCI_IOV
>
>          If unsure, say N.
>
> +config PCI_PRI
> +       bool "PCI PRI support"

Shouldn't this depend on PCI?

It doesn't seem to hurt on PCI-less platforms, but I prefer not seeing
PCI-related
questions when CONFIG_PCI is not set.

> +       select PCI_ATS
> +       help
> +         PRI is the PCI Page Request Interface. It allows PCI devices that are
> +         behind an IOMMU to recover from page faults.
> +
> +         If unsure, say N.
> +

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
