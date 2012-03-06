Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031588Ab2CFXOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:14:05 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57016 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031568Ab2CFXOE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:14:04 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.128.202 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1331018040-30725-24-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org> <1331018040-30725-24-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Mar 2012 16:13:42 -0700
Message-ID: <CAErSpo5TjhNv1W=PxSPO6qXfhW1Mi4dMp83vj82=O_hFOq1vow@mail.gmail.com>
Subject: Re: [PATCH 23/23] x86, PCI: add pcibios_root_rescan
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 12:14 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> need use it to rescan root bus that was not added via acpi probe.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/pci/legacy.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
> index aab0e41..7a7c78f 100644
> --- a/arch/x86/pci/legacy.c
> +++ b/arch/x86/pci/legacy.c
> @@ -79,3 +79,28 @@ int __init pci_subsys_init(void)
>        return 0;
>  }
>  subsys_initcall(pci_subsys_init);
> +
> +void __devinit pcibios_root_rescan(void)
> +{
> +       int busn;
> +       struct pci_bus *bus;
> +
> +       if (pcibios_last_bus <= 0 || pcibios_last_bus > 0xff)
> +               return;
> +
> +       for (busn = 0; busn <= pcibios_last_bus; busn++) {
> +               bus = pci_find_bus(0, busn);
> +
> +               if (bus)
> +                       continue;
> +
> +               bus = __pcibios_scan_specific_bus(busn, false);
> +
> +               if (!bus)
> +                       continue;
> +
> +               pci_assign_unassigned_bus_resources(bus);
> +
> +               pci_bus_add_devices(bus);
> +       }
> +}

Does anybody call this?

Do we need it?  I assume we only care about host bridge hotplug via ACPI on x86.

Please wait a while (at least a day or two) before reposting your
series so people have time to take a look at the current one.  It's a
real nuisance to be working through a large series like this and get
bombed with a repost of the whole thing that tweaks some minor detail.
 I'd rather take some time and get as much of the discussion out of
the way on V1 as possible before getting to V2, V3, V4, etc.

Bjorn
