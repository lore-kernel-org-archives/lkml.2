Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759680Ab2IFUDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:03:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55349 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758131Ab2IFUDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <1346952976-18554-1-git-send-email-mjg@redhat.com>
References: <CAErSpo4A=ZWDuiGCFr6gQnFz--3OReVt0iWmzfjmOSQO=ZHNEw@mail.gmail.com>
 <1346952976-18554-1-git-send-email-mjg@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 6 Sep 2012 13:02:52 -0700
Message-ID: <CAErSpo7F17V3M_d2d_TAGX1uxL3ksB8+CyhTRN9dq+cxAZB08w@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix build warning on 32-bit
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 6, 2012 at 10:36 AM, Matthew Garrett <mjg@redhat.com> wrote:
> Fix up the cast so it doesn't cause issues on 32-bit systems.

Thanks!  I folded this into the original patch and pushed the updated
pci/mjg-pci-roms-from-efi branch.

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/pci/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 3d2752f..1e2deac 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -631,7 +631,7 @@ int pcibios_add_device(struct pci_dev *dev)
>                             (PCI_FUNC(dev->devfn) == rom->function) &&
>                             (dev->vendor == rom->vendor) &&
>                             (dev->device == rom->devid)) {
> -                               dev->rom = (void *)(pa_data +
> +                               dev->rom = (void *)(unsigned long)(pa_data +
>                                       offsetof(struct pci_setup_rom, romdata));
>                                 dev->romlen = rom->pcilen;
>                         }
> --
> 1.7.11.4
>
