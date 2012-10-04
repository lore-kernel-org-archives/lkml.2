Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab2JDKyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 06:54:13 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39739 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2JDKyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 06:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <1349276601-8371-22-git-send-email-florian@openwrt.org>
References: <1349276601-8371-1-git-send-email-florian@openwrt.org> <1349276601-8371-22-git-send-email-florian@openwrt.org>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Thu, 4 Oct 2012 12:53:49 +0200
Message-ID: <CAOiHx==kUd4MCF7iKOPitEEgrXR+_oJL0jCPHvoJ+s90eG1xdg@mail.gmail.com>
Subject: Re: [PATCH 20/25] MIPS: Netlogic: convert to use OHCI platform driver
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Jayachandran C <jayachandranc@netlogicmicro.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 October 2012 17:03, Florian Fainelli <florian@openwrt.org> wrote:
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  arch/mips/netlogic/xlr/platform.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/arch/mips/netlogic/xlr/platform.c b/arch/mips/netlogic/xlr/platform.c
> index 320b7ef..755ddcc 100644
> --- a/arch/mips/netlogic/xlr/platform.c
> +++ b/arch/mips/netlogic/xlr/platform.c
> @@ -16,6 +16,7 @@
>  #include <linux/serial_reg.h>
>  #include <linux/i2c.h>
>  #include <linux/usb/ehci_pdriver.h>
> +#include <linux/usb/ohci_pdriver.h>
>
>  #include <asm/netlogic/haldefs.h>
>  #include <asm/netlogic/xlr/iomap.h>
> @@ -129,6 +130,8 @@ static struct usb_ehci_pdata xls_usb_ehci_pdata = {
>         .need_io_watchdog = 1,
>  };
>
> +static struct usb_ohci_pdata xls_usb_ohci_pdata;
> +
>  static struct platform_device xls_usb_ehci_device =
>                          USB_PLATFORM_DEV("ehci-xls", 0, PIC_USB_IRQ);
>  static struct platform_device xls_usb_ohci_device_0 =

And change after the device names of the ohci devices to "ohci-platform"?

> @@ -183,10 +186,12 @@ int xls_platform_usb_init(void)
>         memres += 0x400;
>         xls_usb_ohci_device_0.resource[0].start = memres;
>         xls_usb_ohci_device_0.resource[0].end = memres + 0x400 - 1;
> +       xls_usb_ohci_device_0.dev.platform_data = &xls_usb_ohci_pdata;
>
>         memres += 0x400;
>         xls_usb_ohci_device_1.resource[0].start = memres;
>         xls_usb_ohci_device_1.resource[0].end = memres + 0x400 - 1;
> +       xls_usb_ohci_device_1.dev.platform_data = &xls_usb_ohci_pdata;
>
>         return platform_add_devices(xls_platform_devices,
>                                 ARRAY_SIZE(xls_platform_devices));
> --
> 1.7.9.5

Jonas
