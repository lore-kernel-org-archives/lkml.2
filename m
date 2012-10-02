Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab2JBUI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:08:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62097 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2JBUIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <1349195816-2225-13-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-13-git-send-email-arnd@arndb.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Oct 2012 14:08:03 -0600
Message-ID: <CAErSpo7rkN_F=AxweoEG3oXj392FvzVGPSKnkXCd=JX6cg0aTA@mail.gmail.com>
Subject: Re: [PATCH 12/17] ARM: iop13xx: mark iop13xx_scan_bus as __devinit
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <kernel@wantstofly.org>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 10:36 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> pci_scan_root_bus is __devinit, so iop13xx_scan_bus has to be the
> same in order to safely call it. This is ok because the function
> itself is only called from the hwpci->scan callback.
>
> WARNING: vmlinux.o(.text+0x10138): Section mismatch in reference from the function iop13xx_scan_bus() to the function .devinit.text:pci_scan_root_bus()
> The function iop13xx_scan_bus() references
> the function __devinit pci_scan_root_bus().
> This is often because iop13xx_scan_bus lacks a __devinit
> annotation or the annotation of pci_scan_root_bus is wrong.

With CONFIG_HOTPLUG going away (I think the current state is that it
is always set to "y"), __devinit will effectively become a no-op, so I
expect we'll remove it from pci_scan_root_bus().

Therefore, I would skip this patch and live with the warning a little longer.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Lennert Buytenhek <kernel@wantstofly.org>
> Cc: Dan Williams <djbw@fb.com>
> ---
>  arch/arm/mach-iop13xx/pci.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
> index 861cb12..9d7f4ca 100644
> --- a/arch/arm/mach-iop13xx/pci.c
> +++ b/arch/arm/mach-iop13xx/pci.c
> @@ -506,7 +506,7 @@ iop13xx_pci_abort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
>
>  /* Scan an IOP13XX PCI bus.  nr selects which ATU we use.
>   */
> -struct pci_bus *iop13xx_scan_bus(int nr, struct pci_sys_data *sys)
> +struct pci_bus * __devinit iop13xx_scan_bus(int nr, struct pci_sys_data *sys)
>  {
>         int which_atu;
>         struct pci_bus *bus = NULL;
> --
> 1.7.10
>
