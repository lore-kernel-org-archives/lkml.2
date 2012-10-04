Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab2JDKvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:51:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2JDKvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:51:22 -0400
MIME-Version: 1.0
In-Reply-To: <1349276601-8371-5-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-5-git-send-email-florian@openwrt.org>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 4 Oct 2012 12:51:01 +0200
Message-ID: <CAOiHx==UaweOJ2sCqkRvW3KWVeGFGoi_YwreNWBo99_Xswv=Kg@mail.gmail.com>
Subject: Re: [PATCH 04/25] MIPS: Netlogic: use ehci-platform driver
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2012 17:02, Florian Fainelli <florian@openwrt.org> wrote:
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  arch/mips/netlogic/xlr/platform.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
> index 71b44d8..1731dfd 100644
> --- a/arch/mips/netlogic/xlr/platform.c
> +++ b/arch/mips/netlogic/xlr/platform.c
> @@ -15,6 +15,7 @@
>  #include <linux/serial_8250.h>
>  #include <linux/serial_reg.h>
>  #include <linux/i2c.h>
> +#include <linux/usb/ehci_pdriver.h>
>
>  #include <asm/netlogic/haldefs.h>
>  #include <asm/netlogic/xlr/iomap.h>
> @@ -123,6 +124,10 @@ static u64 xls_usb_dmamask = ~(u32)0;
>                 },                                                      \
>         }
>
> +static struct usb_ehci_pdata xls_usb_ehci_pdata = {
> +       .caps_offset    = 0,
> +};
> +
>  static struct platform_device xls_usb_ehci_device =
>                          USB_PLATFORM_DEV("ehci-xls", 0, PIC_USB_IRQ);

Don't you also need to change this to "ehci-platform"?

>  static struct platform_device xls_usb_ohci_device_0 =
> @@ -172,6 +177,7 @@ int xls_platform_usb_init(void)
>         memres = CPHYSADDR((unsigned long)usb_mmio);
>         xls_usb_ehci_device.resource[0].start = memres;
>         xls_usb_ehci_device.resource[0].end = memres + 0x400 - 1;
> +       xls_usb_ehci_device.dev.platform_data = &xls_usb_ehci_pdata;
>
>         memres += 0x400;
>         xls_usb_ohci_device_0.resource[0].start = memres;
> --
> 1.7.9.5

Jonas
